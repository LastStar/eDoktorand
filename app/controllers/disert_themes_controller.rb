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
    @disert_theme = DisertTheme.find(@params['id'])
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
    render_partial("shared/approve", :document => @disert_theme)
  end
  
  # confirms and saves statement
  def confirm_approve
    @disert_theme = DisertTheme.find(@params['id'])
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
    @disert_theme.save
    redirect_to :controller => 'students'
  end
end
