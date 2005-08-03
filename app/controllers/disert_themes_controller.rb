class DisertThemesController < ApplicationController
  model :user
  include LoginSystem
  layout 'employers'
  before_filter :login_required, :student_required, :prepare_person
  # page for adding methodology to disert theme
  def methodology
    disert_theme = DisertTheme.find(@params['id'])
  end
  # saves methogology file
  def save_methodology
    DisertTheme.save(@params['disert_theme'])
    dt = DisertTheme.find(@params['disert_theme']['id'])
    dt.update_attribute('methodology_added_on', Time.now)
    redirect_to(:action => 'index', :controller => 'study_plans')
  end
  # approves disertation theme 
  def approve
    @disert_theme = DisertTheme.find(@params['id'])
    @disert_theme.approvement ||= DisertThemeApprovement.create
    prepare_approvement(@disert_theme.approvement)
    render_partial("shared/approve", :document => @disert_theme, :title =>
    _("atestation"), :options => [[_("approve"), 1], [_("cancel"), 0]])
  end
  # confirms and saves statement
  def confirm_approve
    disert_theme = DisertTheme.find(@params['id'])
    if @session['user'].person.is_a?(Tutor) && 
      !disert_theme.approvement.tutor_statement
      @statement = TutorStatement.create(@params['statement'])
      disert_theme.approvement.tutor_statement = @statement
    elsif @session['user'].person.is_a?(Leader) &&
      !disert_theme.approvement.leader_statement
      @statement = LeaderStatement.create(@params['statement'])
      disert_theme.approvement.leader_statement = @statement
    elsif @session['user'].person.is_a?(Dean) 
      @statement = DeanStatement.create(@params['statement'])
      disert_theme.approvement.dean_statement = @statement
    end
    disert_theme.save
    render(:partial => 'statement', :locals => {:approvement => @approvement, :element => "approve_form#{disert_theme.id}"})
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
      disert_theme, :element => 'methodology_form' })
    else
      render(:partial => 'notvalid_methodology', :locals => {:disert_theme =>
      disert_theme}) 
    end
  end
  # renders partial for upload methodology form
  def upload_methodology
    @title = _("Upload disert theme") 
    @disert_theme = DisertTheme.find(@params['id'])
  end
end
