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
  # namely obligate subjects
  def create
    prepare_plan_session
    @title = _("Creating study plan")
    if RequisiteSubject.has_for_coridor?(@student.index.coridor)
      create_requisite
    end
    create_obligate
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
    extract_voluntary
    count = FACULTY_CFG[@student.faculty.id]['subjects_count'] -
    @session['plan_subjects'].size
    if @plan_subjects.map {|ps| ps.subject_id}.uniq.size >= count && @errors.empty?
      @plan_subjects.each {|ps| last_semester(ps.finishing_on)}
      @session['plan_subjects'] << @plan_subjects
      voluntary_subjects = @plan_subjects
      create_language
      render(:partial => 'languages', :locals => {:plan_subjects =>
      voluntary_subjects, :study_plan => @session['study_plan']})  
    else
      extract_voluntary(true)
      @errors << _("subjects have to be different") unless @plan_subjects.map {|ps| ps.subject_id}.uniq.size == 3
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
    render(:partial => 'shared/show', :locals => {:remove =>
    "approve_form#{study_plan.id}", :study_plan => study_plan})
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
  # renders study plan
  def show
    study_plan = StudyPlan.find(@params['id'])
    render(:partial => 'shared/show', :locals => {:study_plan => study_plan, :remove =>
    nil})
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
end
