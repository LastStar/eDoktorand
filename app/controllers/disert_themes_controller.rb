class DisertThemesController < ApplicationController
  include LoginSystem
  layout 'students'
  before_filter :login_required, :student_required
  # page for adding methodology to disert theme
  def methodology
    @title = _("Upload methodology")
    @disert_theme = DisertTheme.find(@params['id'])
  end
  # saves methogology file
  def save_methodology
    DisertTheme.save(@params['disert_theme'])
    dt = DisertTheme.find(@params['disert_theme']['id'])
    dt.update_attribute('methodology_added_on', Time.now)
    redirect_to :controller => 'study_plans'
  end

  # approves disertation theme 
  def approve
    @study_plan = StudyPlan.find(@params['id'])
    @disert_theme = @study_plan.index.disert_theme

    @title = _("Approve methodology for ") +
    @disert_theme.index.student.display_name
    @disert_theme.approvement ||= Approvement.create
    if @session['user'].person.is_a?(Tutor) &&
      !@disert_theme.approvement.tutor_statement
      @statement = TutorStatement.new
    elsif @session['user'].person.is_a?(Leader) &&
      !@disert_theme.approvement.leader_statement
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
    @disert_theme = @study_plan.index.disert_theme
    if @session['user'].person.is_a?(Tutor) && 
      !@disert_theme.approvement.tutor_statement
      @statement = TutorStatement.create(@params['statement'])
      @disert_theme.approvement.tutor_statement = @statement
    elsif @session['user'].person.is_a?(Leader) &&
      !@disert_theme.approvement.leader_statement
      @statement = LeaderStatement.create(@params['statement'])
      @disert_theme.approvement.leader_statement = @statement
    elsif @session['user'].person.is_a?(Dean) 
      @statement = DeanStatement.create(@params['statement'])
      @disert_theme.approvement.dean_statement = @statement
    end
    #@disert_theme.canceled_on = @statement.cancel? ? Time.now : nil
    #@disert_theme.approved_on = Time.now if @statement.is_a?(DeanStatement) &&
    #!@statement.cancel?
    @disert_theme.save
    redirect_to :action => 'show', :id => @study_plan.id
  end
end
