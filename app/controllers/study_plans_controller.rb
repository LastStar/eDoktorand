class StudyPlansController < ApplicationController
  include LoginSystem
  model :student
  model :user
  model :leader
  model :dean
  model :language_subject
  model :external_subject
  layout 'students'
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
      redirect_to :action => 'choose_subjects'
    end
  end
  # page where student adds subjects to his study plan
  def choose_subjects
    @title = _("Creating study plan")
    @study_plan = @student.index.build_study_plan
    @obligate_subjects = @student.index.coridor.obligate_subjects
  end
  # saves study plan
  def save
    @study_plan = StudyPlan.new(@params['study_plan'])
    flash.now[:errors] = []
    @study_plan.save
    prepare_obligate
    prepare_language
    prepare_voluntary
    unless flash[:errors].empty?
      choose_subjects
      render_action 'choose_subjects'
    else
      @session['study_plan'] = @study_plan
      redirect_to :action => 'preview'
    end
  end
  # previews what have been filled. 
  def preview
    @title = _("Creating study plan")
    @study_plan = @session['study_plan']
    @study_plan.index.disert_theme = @session['disert_theme']
  end
  # confirms study plan 
  def confirm
    @study_plan = @session['study_plan']
    @study_plan.admited_on = Time.now
    @study_plan.save
    redirect_to :action => 'index'
  end
  # shows study plan to employer
  def show
    @study_plan = StudyPlan.find(@params['id'])
    @title = _("Study plan for ") + @study_plan.index.student.display_name 
  end
  # approves study plan 
  def approve
    @study_plan = StudyPlan.find(@params['id'])
    @title = _("Approve study plan for ") +
    @study_plan.index.student.display_name
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
      @flash['error'] = _("you don't have rights to do this")
      redirect_to :action => 'login', :controller => 'account'
    end
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
    redirect_to :action => 'show', :id => @study_plan.id
  end
  private	
  # gets obligate subjects from request
  def prepare_obligate
    @params['obligate_semester'].each do |key, value|
      @study_plan.plan_subjects.create('subject_id' => key,
      'finishing_on' => value)
    end
  end
  # gets language  subject from request
  def prepare_language
    unless @params['language'].values.uniq.size == 1
      @params['language'].each do  |key, value|
        @study_plan.plan_subjects.create('subject_id' => value,
        'finishing_on' => @params['language_semester'][key])
      end
    else
      flash[:errors] << _("languages have to be different")
    end
  end
  # gets voluntary subject from request
  def prepare_voluntary
    @params['voluntary'].each do |key, value|
      if value == '0'
        es = ExternalSubject.new('label' => 
        @params['voluntary_subject'][key])
        if es.save
          if es.create_external_subject_detail(
            'university' => @params['voluntary_university'][key],
            'person' => @params['voluntary_examinator'][key])
            value = es.id
          else 
            flash[:errors] << _("university for external subject cannot be
            empty")
          end
        else
          flash[:errors] << _("name of the external subject cannot be empty")
        end
      end
      @study_plan.plan_subjects.create('subject_id' => value,
      'finishing_on' => @params['voluntary_semester'][key])
      flash[:errors].uniq!
    end
  end
end
