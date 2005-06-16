class StudyPlansController < ApplicationController
  include LoginSystem
  model :student
  model :user
  model :leader
  model :dean
  model :language_subject
  model :external_subject
  model :study_plan
  model :plan_subject
  model :subject
  layout 'employers'
  before_filter :login_required, :student_required
  # page with basic informations for student 
  def index
    @title = _("Study plan")
    @study_plan = @student.index.study_plan
  end
  # start of the study plan creating process
  # namely disert theme
  def create
    @title = _("Creating study plan")
    @disert_theme = @student.index.build_disert_theme
  end
  # saves disert theme to session
  def save_disert
    @disert_theme = DisertTheme.new(@params['disert_theme'])
    unless @disert_theme.valid?
      render_action 'create'
    else
      @session['disert_theme'] = @disert_theme
      redirect_to :action => 'choose_obligate'
    end
  end
  # page where student adds obligate subjects to his study plan
  def choose_obligate
    @title = _("Creating study plan")
    @study_plan = @student.index.build_study_plan
    @session['study_plan'] = @study_plan
    @session['plan_subjects'] = []
    create_obligate
  end
  # saves obligate subjects to session
  def save_obligate
    @session['study_plan'].attributes = @params['study_plan']
    @params['plan_subject'].each do |id, ps|
      plan_subject = PlanSubject.new
      plan_subject.attributes = ps
      @session['plan_subjects'] << plan_subject
    end
    redirect_to :action => 'choose_language'
  end
  # page where student adds language subjects to his study plan
  def choose_language
    @title = _("Creating study plan")
    @study_plan = StudyPlan.new
    create_language
  end
  # saves language subjects to session
  def save_language
    extract_language
    if @plan_subjects.map {|ps| ps.subject_id}.uniq.size == 2
      @session['plan_subjects'] << @plan_subjects
      redirect_to :action => 'choose_voluntary'
    else
      extract_language(true)
      @title = _("Error in creating study plan")
      flash.now['error'] = _("languages have to be different")
      render_action 'choose_language'
    end
  end
  # page where student adds voluntary subjects to his study plan
  def choose_voluntary
    @title = _("Creating study plan")
    @study_plan = StudyPlan.new
    create_voluntary
  end
  # saves voluntary subjects to session
  def save_voluntary
    @errors = []
    extract_voluntary
    if @plan_subjects.map {|ps| ps.subject_id}.uniq.size == 3 && @errors.empty?
      @session['plan_subjects'] << @plan_subjects
      redirect_to :action => 'preview'
    else
      extract_voluntary(true)
      @title = _("Error in creating study plan")
      @errors << _("subjects have to be different") unless @plan_subjects.map {|ps| ps.subject_id}.uniq.size == 3
      flash.now['errors'] = @errors.uniq!
      render_action 'choose_voluntary'
    end
  end
  # previews what have been filled. 
  def preview
    @title = _("Creating study plan")
    @study_plan = @session['study_plan']
    @study_plan.plan_subjects << @session['plan_subjects']
    @study_plan.index.disert_theme = @session['disert_theme']
  end
  # confirms study plan 
  def confirm
    @study_plan = @session['study_plan']
    @study_plan.admited_on = Time.now
    @study_plan.plan_subjects << @session['plan_subjects']
    @study_plan.index.disert_theme = @session['disert_theme']
    @study_plan.save
    @session['study_plan'] = nil
    @session['plan_subjects'] = nil
    @session['disert_theme'] = nil
    redirect_to :action => 'index'
  end
  # approves study plan 
  def approve
    @study_plan = StudyPlan.find(@params['id'])
    @study_plan.approvement ||= Approvement.create
    if @session['user'].person.is_a?(Tutor) &&
      !@study_plan.approvement.tutor_statement
      @statement = TutorStatement.new
    elsif @session['user'].person.is_a?(Leader) &&
      !@study_plan.approvement.leader_statement
      @statement = LeaderStatement.new
    elsif @session['user'].person.is_a?(Dean)
      @statement = DeanStatement.new
    else
      flash['error'] = _("you don't have rights to do this")
      redirect_to :action => 'login', :controller => 'account'
    end
    render_partial("shared/approve", :document => @study_plan)
  end
  # confirms and saves statement
  def confirm_approve
    @study_plan = StudyPlan.find(@params['id'])
    if @session['user'].person.is_a?(Tutor) && 
      !@study_plan.approvement.tutor_statement
      @statement = TutorStatement.create(@params['statement'])
      @study_plan.approvement.tutor_statement = @statement
    elsif @session['user'].person.is_a?(Leader) &&
      !@study_plan.approvement.leader_statement
      @statement = LeaderStatement.create(@params['statement'])
      @study_plan.approvement.leader_statement = @statement
    elsif @session['user'].person.is_a?(Dean) 
      @statement = DeanStatement.create(@params['statement'])
      @study_plan.approvement.dean_statement = @statement
    end
    @study_plan.canceled_on = @statement.cancel? ? Time.now : nil
    @study_plan.approved_on = Time.now if @statement.is_a?(DeanStatement) &&
      !@statement.cancel?
    @study_plan.save
    redirect_to :controller => 'students'
  end
  # for remote adding subjects to page
  def subjects
    render_partial("shared/subjects", :subjects =>
    PlanSubject.find(:all, :contions => ['study_plan_id = ?', @params['id']],
    :include => [:subject]))
  end
  private	
  # prepares obligate subjects
  def create_obligate
    @plan_subjects = []
    index = 0
    @study_plan.index.coridor.obligate_subjects.each do |sub|
      ps = PlanSubject.new('subject_id' => sub.id)
      ps.id = index
      @plan_subjects << ps
      index += 1
    end
  end
  # prepares language  subject
  def create_language
    @plan_subjects = []
    (1..2).each do |index|
      ps = PlanSubject.new
      ps.id = index
      @plan_subjects << ps
    end
  end
  # prepares voluntary subject 
  def create_voluntary
    @plan_subjects = []
    (1..3).each do |index|
      ps = PlanSubject.new
      ps.id = index
      @plan_subjects << ps
    end
  end
  # extracts language subjects from request
  def extract_language(remap_id = false)
    @plan_subjects = []
    @params['plan_subject'].each do |id, ps|
      plan_subject = PlanSubject.new
      plan_subject.attributes = ps
      plan_subject.id = id if remap_id
      @plan_subjects << plan_subject
    end
  end
  # extracts voluntary subjects from request
  def extract_voluntary(remap_id = false)
    @plan_subjects = []
    @params['plan_subject'].each do |id, ps|
      if(ps['subject_id'] == '0')
        subject = ExternalSubject.new
        subject.label = ps['label']
        unless subject.valid?
          @errors << _("title for external subject cannot be empty")
        end
        esd =
        subject.build_external_subject_detail(@params['external_subject_detail'][id])
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
      plan_subject.id = id if remap_id
      @plan_subjects << plan_subject
    end
  end
end
