# require 'study_plan_creator'
class StudyPlansController < ApplicationController
  include LoginSystem
  helper :students
  layout 'employers', :except => [:add_en, :save_en]
  before_filter :login_required, :prepare_user, :prepare_student
  
  # page with basic informations for student 
  def index
    @title = _("Study plan")
    @index = @student.index
    @voluntary_subjects = @index.coridor.voluntary_subjects 
  end
  
  # start of the study plan creating process
  def create
    prepare_plan_session
    @title = _("Creating study plan")
    if ObligateSubject.has_for_coridor?(@student.coridor)
      @type = 'obligate'
    elsif SeminarSubject.has_for_coridor?(@student.coridor)
      @type = 'seminar'
    else
      @type = 'voluntary'
    end
  end

  # create study plan like no-student 
  def create_by_other
    @student = Student.find(params[:id])
    @title = _("Creating study plan")
    @requisite_subjects = PlanSubject.create_for(@student, :requisite)
    @subjects = CoridorSubject.for_select(:coridor => @student.index.coridor)
    @study_plan = @student.index.prepare_study_plan
    @plan_subjects = []
    (FACULTY_CFG[@student.faculty.id]['subjects_count'] + 3).times do |i|
      (plan_subject = PlanSubject.new('subject_id' => -1)).id = (i+1)
      @plan_subjects << plan_subject
    end
    @disert_theme = @student.index.build_disert_theme
  end
  
  # renders change page for study plan
  def change
    @title = _('Change of study plan')
    if !@student
      @student = Student.find(params[:id])
    end
    coridor = @student.index.coridor
    @subjects = CoridorSubject.for_select(:coridor => coridor)
    if @study_plan = @student.index.study_plan
      @plan_subjects = @study_plan.unfinished_subjects
      (FACULTY_CFG[@student.faculty.id]['subjects_count'] - @plan_subjects.size + 4).times do |i|
        (plan_subject = PlanSubject.new('subject_id' => -1)).id = (i+1)
        @plan_subjects << plan_subject
      end
      session[:finished_subjects] = @student.index.study_plan.finished_subjects
      @disert_theme = @student.index.disert_theme
    else
      create_by_other
    end
    render(:action => 'create_by_other')
  end
  
  # saves obligate subjects to session
  # and creates voluntary subjects
  def save_obligate
    @created_subjects = []
    session[:plan_subjects] = []
    if params[:study_plan]
      session[:study_plan].attributes = params[:study_plan]
    end
    plan_subjects = params[:plan_subject]
    if session[:obligate_subjects].empty?
      plan_subjects.each do |id, ps|
        plan_subject = PlanSubject.new(ps)
        last_semester(ps['finishing_on'])
        @created_subjects << plan_subject
      end
    else
      plan_subjects.each do |ps|
        plan_subject = PlanSubject.new(ps)
        last_semester(ps['finishing_on'])
        @created_subjects << plan_subject
      end
    end
    session[:plan_subjects].concat(@created_subjects)
    session[:obligate_subjects] = @created_subjects
    create_voluntary
    @type = 'obligate'
  end
  
  # saves seminar subjects to session 
  # and creates voluntary subjects
  def save_seminar
    extract_seminar
    if session[:seminar_subjects].map {|ps| ps.subject_id}.uniq.size < session[:seminar_subjects].size
      flash[:error] = _('subjects have to be different')
      render(:partial => 'not_valid_seminar')
    else
      @created_subjects = session[:seminar_subjects]
      @type = 'voluntary'
      @return_to = 'seminar'
      render(:action => :save_obligate)
    end
  end
  
  # saves voluntary subjects to session and prepares disert theme
  def save_voluntary
    if params[:return] == '1'
      render(:partial => 'not_valid_seminar')
    else
      @errors = []
      external = extract_voluntary
      if session[:voluntary_subjects].map {|ps| ps.subject_id}.uniq.size == session[:voluntary_subjects].size &&
        @errors.empty?
        session[:voluntary_subjects].each {|ps| last_semester(ps.finishing_on)}
      else
        extract_voluntary
        @errors << _("subjects have to be different") if session[:voluntary_subjects].map {|ps| ps.subject_id}.uniq.size < session[:voluntary_subjects].size
        flash[:errors] = @errors.uniq
        @return_to = 'seminar'
        render(:partial => 'not_valid_voluntarys')
      end
    end
  end
  
  # saves language subjects to session and creates voluntary subjects
  def save_language
    if params[:return] == '1'
      render(:partial => 'not_valid_voluntarys')
    else
      extract_language
      if session[:language_subjects].map {|ps| ps.subject_id}.uniq.size == 2
        session[:disert_theme] = @student.index.build_disert_theme
      else
        flash.now[:error] = _("languages have to be different")
        render(:partial => 'not_valid_languages')  
      end
    end
  end
  
  # saves disert theme to session
  def save_disert
    if params[:return] == '1'
      render(:partial => 'not_valid_languages')
    else
      session[:study_plan].attributes = params[:study_plan]
      session[:study_plan].index = @student.index
      session[:disert_theme] = DisertTheme.new(params[:disert_theme])
      unless session[:disert_theme].valid?
        render(:partial => 'not_valid_disert', 
               :locals => {:disert_theme => session[:disert_theme]})
      end
    end
  end
  
  # saves full form
  def save_full
    @errors = []
    extract_voluntary
    @student = Student.find(params[:student][:id])
    if @student.study_plan && @student.study_plan.atestation
      @atestation = @student.study_plan.atestation 
    end
    unless session[:voluntary_subjects].map {|ps| ps.subject_id}.uniq.size <= session[:voluntary_subjects].size
      @errors << _("subjects have to be different")     
    end
    @study_plan = StudyPlan.new(params[:study_plan])
    @study_plan.plan_subjects = reindex_plan_subjects(session[:voluntary_subjects])
    if session[:finished_subjects]
      session[:finished_subjects].each do |sub|
       @study_plan.plan_subjects << sub.clone 
      end 
    end
    @disert_theme = DisertTheme.new(params[:disert_theme])
    @disert_theme.index = @student.index
    @study_plan.admited_on = Time.now
    @study_plan.index = @student.index
    if @study_plan.valid? && @disert_theme.valid? && @errors.empty?
      @study_plan.save
      @atestation.update_attribute(:document_id, @study_plan.id) if @atestation
      @disert_theme.save
      if @user.person.is_a?(Student)
        if session[:interupt]
          redirect_to(:controller => 'interupts', :action => 'finish')
        else
          redirect_to(:controller => 'study_plans')
        end
      else
        redirect_to(:controller => 'students')
      end
    else
      @subjects = CoridorSubject.for_select(:coridor => @student.index.coridor)
      render(:action => 'create_by_other')
    end
  end
  
  # confirms study plan 
  def confirm
    @study_plan = session[:study_plan]
    @study_plan.admited_on = Time.now
    @study_plan.plan_subjects = concat_plan_subjects
    @study_plan.index_id = @student.index.id
    disert_theme = session[:disert_theme]
    disert_theme.index = @study_plan.index 
    disert_theme.save
    Notifications::deliver_study_plan_create(@study_plan)
    @study_plan.save
    reset_plan_session
    redirect_to :action => 'index'
  end
  
  # confirms and saves statement
  def confirm_approve
    study_plan = StudyPlan.find(params[:id])
    study_plan.approve_with(params[:statement])
    render(:partial => 'shared/confirm_approve',
           :locals => {:document => study_plan})
  end
  
  # atests study plan 
  def atest
    @study_plan = StudyPlan.find(params[:id])
  end
  
  # confirms and saves statement
  def confirm_atest
    study_plan = StudyPlan.find(params[:id])
    study_plan.atest_with(params[:statement])
    render(:partial => 'shared/confirm_approve', 
           :locals => {:replace => 'atestation', :document => study_plan,
                       :approvement => study_plan.atestation})
  end
  
  # for remote adding subjects to page
  def subjects
    render(:partial => 'plan_subjects', :locals => {:subjects =>
    PlanSubject.find(:all, :conditions => ['study_plan_id = ?', params[:id]],
    :include => [:subject]), :study_plan => StudyPlan.find(params[:id])})
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
    atestation_detail = AtestationDetail.create(params[:atestation_detail])  
    render(:partial => 'after_save_detail', :locals => {:study_plan => 
    @student.index.study_plan})
  end

  def final_application
    @study_plan = @student.index.study_plan
  end

  def save_final_application
    @study_plan = @student.index.study_plan
    @study_plan.update_attributes(params['study_plan'])
    @study_plan.index.claim_final_application!
    redirect_to :action => :index
  end
  
  #adding only final_areas en (fixing bug)
  def add_en
    @id = Index.find(params[:id])
    @final_area_id = params[:final_area_id]
  end
  
  #saving only final_areas en (fixing bug)
  def save_en
    @id = Index.find(params[:id])
    @study_plan = @id.study_plan
    @final_area_id = params[:final_area_id]
    @study_plan.final_areas['en'][params[:final_area_id]] = params[:en_title]
    @study_plan.save
  end
  
private
  def reset_plan_session
    session[:study_plan] = nil
    session[:disert_theme] = nil
    session[:last_semester] = nil
  end

  # prepare variables used in creation form
  def prepare_plan_session
    session[:study_plan] = @study_plan = @student.index.build_study_plan
    session[:disert_theme] = nil
    session[:last_semester] = nil
    if RequisiteSubject.has_for_coridor?(@student.coridor)
      session[:requisite_subjects] = PlanSubject.create_for(@student, :requisite)
    end
    if ObligateSubject.has_for_coridor?(@student.coridor)
      session[:obligate_subjects] = PlanSubject.create_for(@student, :obligate)
    end
    if SeminarSubject.has_for_coridor?(@student.coridor)
      session[:seminar_subjects] = PlanSubject.create_for(@student, :seminar)
    end
    session[:voluntary_subjects] = PlanSubject.create_for(@student.index.coridor, :voluntary)
    session[:language_subjects] = PlanSubject.create_for(@student.index.coridor, :language)
  end

  # controls last semester
  def last_semester(semester)
    session[:last_semester] ||= 0
    if session[:last_semester] < semester.to_i
      session[:last_semester] = semester.to_i   
    end
  end

  def extract_voluntary
    external = 0
    session[:voluntary_subjects] = []
    params[:plan_subject].each do |id, ps|
      next if ps['subject_id'] == '-1'
      if ps['subject_id'] == '0' 
        external += 1
        subject = ExternalSubject.new
        subject.label = ps['label']
        subject.label_en = ps['label_en']
        unless subject.valid?
          @errors << _("title for external subject cannot be empty")
        end
        esd = subject.build_external_subject_detail(params[:external_subject_detail][id])
        unless esd.valid?
          @errors << _("university for external subject cannot be empty")
        else
          subject.external_subject_detail = esd
        end
      else
        subject = Subject.find(ps['subject_id'])
      end
      plan_subject = PlanSubject.new
      plan_subject.finishing_on = ps['finishing_on']
      plan_subject.subject = subject
      plan_subject.id = id
      session[:voluntary_subjects] << plan_subject
    end
    # BLOODY HACK
    unless external == 0
      return external - 1
    else
      return 0
    end
  end

  def extract_language
    session[:language_subjects] = []
    params[:plan_subject].each do |id, ps|
      plan_subject = PlanSubject.new(ps)
      plan_subject.id = id
      last_semester(ps['finishing_on'])
      session[:language_subjects] << plan_subject
    end
  end

  def extract_seminar
    session[:seminar_subjects] = []
    params[:plan_subject].each do |id, ps|
      plan_subject = PlanSubject.new(ps)
      plan_subject.id = id
      last_semester(ps['finishing_on'])
      session[:seminar_subjects] << plan_subject
    end
  end

  def concat_plan_subjects
    plan_subjects = session[:voluntary_subjects].concat(session[:language_subjects])
    if session[:requisite_subjects]
      plan_subjects.concat(session[:requisite_subjects]) 
    end
    if session[:seminar_subjects]
      plan_subjects.concat(session[:seminar_subjects]) 
    end
    if session[:obligate_subjects]
      plan_subjects.concat(session[:obligate_subjects]) 
    end
    reindex_plan_subjects(plan_subjects)
  end

  def reindex_plan_subjects(plan_subjects)
    plan_subjects.map do |ps|
      PlanSubject.new(ps.attributes)
    end
  end
end
