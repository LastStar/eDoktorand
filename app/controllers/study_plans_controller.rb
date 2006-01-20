require 'study_plan_creator'
class StudyPlansController < ApplicationController
  include LoginSystem
  layout 'employers'
  before_filter :login_required, :prepare_student, :prepare_user
  
  # page with basic informations for student 
  def index
    @title = _("Study plan")
    @study_plan = @student.index.study_plan
  end
  
  # start of the study plan creating process
  def create
    prepare_plan_session
    @title = _("Creating study plan")
    if RequisiteSubject.has_for_coridor?(@student.index.coridor)
      create_requisite
    end
    create_obligate
  end
  
  # create study plan like no-student 
  def create_by_other
    @student = Student.find(@params['id'])
    @title = _("Creating study plan")
    @requisite_subjects = prepare_requisite(@student)
    @subjects = Subject.for_faculty_select(@student.faculty)
    @subjects.concat(LanguageSubject.for_select)
    @study_plan = @student.index.build_study_plan
    @plan_subjects = []
    10.times do |i|
      (plan_subject = PlanSubject.new('subject_id' => -1)).id = (i+1)
      @plan_subjects << plan_subject
    end
    @disert_theme = @student.index.build_disert_theme
  end
  
  # renders change page for study plan
  def change
    if !@student
      @student = Student.find(@params['id'])
    end
    @subjects = VoluntarySubject.for_select(@student.index.coridor)
    @subjects.concat(ObligateSubject.for_select(@student.index.coridor))
    @subjects.concat(LanguageSubject.for_select)
    @subjects.concat(RequisiteSubject.for_select(@student.index.coridor))
    if @study_plan = @student.index.study_plan
      @plan_subjects = @student.index.study_plan.unfinished_subjects
      @session['finished_subjects'] = @student.index.study_plan.finished_subjects
      @disert_theme = @student.index.disert_theme
    else
      create_by_other
    end
    render(:action => 'create_by_other')
  end
  
  # saves obligate subjects to session
  # and creates voluntary subjects
  def save_obligate
    created_subjects = []
    @session['study_plan'].attributes = @params['study_plan']
    @params['plan_subject'].each do |id, ps|
      plan_subject = PlanSubject.new(ps)
      last_semester(ps['finishing_on'])
      created_subjects << plan_subject
    end
    @session['plan_subjects'].concat(created_subjects)
    create_voluntary
    @type = 'obligate'
    render(:partial => 'voluntarys', :locals => {:plan_subjects =>
           created_subjects})
  end
  
  # saves seminar subjects to session
  
  # and creates voluntary subjects
  def save_seminar
    @session['study_plan'].attributes = @params['study_plan']
    2.times do |i|
      plan_subject = PlanSubject.new('subject_id' => @params['plan_subject'])
      last_semester(@params['plan_subject_finishing_on'][i.to_s])
      plan_subject.finishing_on = @params['plan_subject_finishing_on'][i.to_s]
      @session['plan_subjects'] << plan_subject
    end
    create_voluntary
    @type = 'seminar'
    render(:partial => 'voluntarys', :locals => {:plan_subjects =>
           @session['plan_subjects'], :form_plan_subjects => @plan_subjects})
  end
  
  # saves voluntary subjects to session
  
  # and prepares disert theme
  def save_voluntary
    @errors = []
    external = extract_voluntary
    count = FACULTY_CFG[@student.faculty.id]['subjects_count'] -
      @session['plan_subjects'].size
    if @plan_subjects.map {|ps| ps.subject_id}.uniq.size >= (count - external) &&
      @errors.empty?
      @plan_subjects.each {|ps| last_semester(ps.finishing_on)}
      @session['plan_subjects'] << @plan_subjects
      voluntary_subjects = @plan_subjects
      create_language
      render(:partial => 'languages', :locals => {:plan_subjects =>
             voluntary_subjects, :study_plan => @session['study_plan']})  
    else
      extract_voluntary(true)
      @errors << _("subjects have to be different") unless @plan_subjects.map {|ps| ps.subject_id}.uniq.size < (count - external)
      flash.now['errors'] = @errors.uniq
      render(:partial => 'not_valid_voluntarys', :locals => {:form_plan_subjects => @plan_subjects})
    end
  end
  
  # saves language subjects to session
  
  # and creates voluntary subjects
  def save_language
    extract_language
    if @plan_subjects.map {|ps| ps.subject_id}.uniq.size == 2
      @session['plan_subjects'] << @plan_subjects
      disert_theme = @student.index.build_disert_theme
      render(:partial => 'valid_languages', :locals => {:plan_subjects =>
             @plan_subjects, :disert_theme => disert_theme})
    else
      extract_language(true)
      flash.now['error'] = _("languages have to be different")
      render(:partial => 'not_valid_languages')  
    end
  end
  
  # saves disert theme to session
  def save_disert
    @session['study_plan'].attributes = @params['study_plan']
    @disert_theme = DisertTheme.new(@params['disert_theme'])
    unless @disert_theme.valid?
      render(:partial => 'not_valid_disert', :locals => {:disert_theme =>
             @disert_theme})
    else
      @session['disert_theme'] = @disert_theme
      render(:partial => 'valid_disert', :locals => {:disert_theme =>
             @disert_theme, :study_plan => @session['study_plan']}) 
    end
  end
  
  # saves full form
  def save_full
    @errors = []
    extract_voluntary
    @student = Student.find(@params['student']['id'])
    if @session['finished_subjects']
      @session['finished_subjects'].each do |sub|
       @plan_subjects << sub.clone 
      end 
    end
    unless @plan_subjects.map {|ps| ps.subject_id}.uniq.size <= @plan_subjects.size
      @errors << _("subjects have to be different")     
    end
    @study_plan = StudyPlan.new(@params['study_plan'])
    @disert_theme = DisertTheme.new(@params['disert_theme'])
    @disert_theme.index = @student.index
    @study_plan.admited_on = Time.now
    @study_plan.index = @student.index
    if @study_plan.valid? && @disert_theme.valid? && @errors.empty?
      @study_plan.save
      @disert_theme.save
      @plan_subjects.each do |ps|
        ps.study_plan = @study_plan
        ps.save
      end
      if @user.person.is_a?(Student)
        if @session['interupt']
          redirect_to(:controller => 'interupts', :action => 'finish')
        else
          redirect_to(:controller => 'study_plans')
        end
      else
        redirect_to(:action => 'list', :controller => 'students')
      end
    else
      @subjects = Subject.for_faculty_select(@student.faculty)
      extract_voluntary
      render(:action => 'create_by_other')
    end
  end
  
  # confirms study plan 
  def confirm
    @study_plan = @session['study_plan']
    @study_plan.admited_on = Time.now
    @study_plan.plan_subjects << @session['plan_subjects']
    @study_plan.index_id = @student.index.id
    disert_theme = @session['disert_theme']
    disert_theme.index = @study_plan.index 
    disert_theme.save
    @study_plan.save
    prepare_plan_session
    redirect_to :action => 'index'
  end
  
  # confirms and saves statement
  def confirm_approve
    study_plan = StudyPlan.find(@params['id'])
    study_plan.approve_with(@params['statement'])
    render(:inline => "Element.hide('approve_form#{study_plan.id}'); \
      Element.remove('index_line_#{study_plan.index.id}')")
  end
  
  # atests study plan 
  def atest
    study_plan = StudyPlan.find(@params['id'])
    render(:partial => 'show_atestation', :locals => {:study_plan => study_plan})
  end
  
  # confirms and saves statement
  def confirm_atest
    study_plan = StudyPlan.find(@params['id'])
    statement = \
    eval("#{@params['statement']['type']}.create(@params['statement'])") 
    eval("study_plan.atestation.#{@params['statement']['type'].underscore} =
      statement")
    if statement.cancel? && statement.is_a?(DeanStatement)
      study_plan.index.finished_on = Time.now 
      study_plan.index.save
    end
    study_plan.save
    render(:partial => 'shared/show', :locals => {:remove =>
      "approve_form#{study_plan.id}", :study_plan => study_plan})
  end
  
  # for remote adding subjects to page
  def subjects
    render(:partial => 'plan_subjects', :locals => {:subjects =>
    PlanSubject.find(:all, :conditions => ['study_plan_id = ?', @params['id']],
    :include => [:subject]), :study_plan => StudyPlan.find(@params['id'])})
  end
  
  # prepares form for atestation details
  def atestation_details
    @atestation_detail = @student.index.study_plan.next_atestation_detail ||
    AtestationDetail.new('study_plan_id' => @student.index.study_plan.id,
    'atestation_term' => Atestation.next_for_faculty(@student.faculty)) 
    render(:partial => 'show_detail_form', :locals => {:study_plan =>
    @student.index.study_plan})
  end
  
  # saves atestation detail 
  def save_atestation_detail
    atestation_detail = AtestationDetail.create(@params['atestation_detail'])  
    render(:partial => 'after_save_detail', :locals => {:study_plan => 
    @student.index.study_plan})
  end

  private 

  include StudyPlanCreator
  # returns requisite subject like plansubjects for student
  def prepare_requisite(student)
    student.index.coridor.requisite_subjects.map do |sub|
      PlanSubject.new('subject_id' => sub.subject.id, 'finishing_on' => 
        sub.requisite_on)
    end
  end
end
