class DisertThemesController < ApplicationController
  include LoginSystem
  layout 'students'
  before_filter :login_required, :student_required
  # page for adding methodology to disert theme
  def methodology
    disert_theme = DisertTheme.find(@params['id'])
  end
  # saves methogology file
  def save_methodology
    DisertTheme.save(@params['disert_theme'])
    dt = DisertTheme.find(@params['disert_theme']['id'])
    dt.update_attribute('methodology_added_on', Time.now)
    render(:partial => 'methodology_saved', :locals => {:disert_theme => dt})
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
  # renders partial for adding methodology summary do disert theme
  def methodology_summary
    render(:partial => 'methodology_summary', :locals => {:disert_theme =>
    DisertTheme.find(@params['id'])})
  end
  # saves methodology summary and renders new disert theme
  def save_methodology_summary
    disert_theme = DisertTheme.find(@params['disert_theme']['id'])
    disert_theme.methodology_summary = @params['disert_theme']['methodology_summary']
    if disert_theme.save
      render(:partial => 'valid_methodology', :locals => {:disert_theme =>
      disert_theme})
    else
      render(:partial => 'notvalid_methodology', :locals => {:disert_theme =>
      disert_theme}) 
    end
  end
end
