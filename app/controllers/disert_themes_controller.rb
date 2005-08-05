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
    disert_theme = DisertTheme.find(@params['id'])
    disert_theme.approvement ||= DisertThemeApprovement.create
    approvement = disert_theme.approvement
    @statement = prepare_statement(disert_theme.approvement)
    render_partial("shared/approve", :approvement => approvement, :title =>
    _("atestation"), :options => [[_("approve"), 1], [_("cancel"), 0]])
  end
  # confirms and saves statement
  def confirm_approve
    disert_theme = DisertTheme.find(@params['id'])
    # this way must go to hell. Compare with last revision
    statement = \
    eval("#{@params['statement']['type']}.create(@params['statement'])") 
    eval("disert_theme.approvement.#{@params['statement']['type'].underscore} =
    statement")
    if statement.cancel?
      disert_theme.clone.reset
    elsif statement.is_a?(DeanStatement)
      disert_theme.approved_on = Time.now
    end
    disert_theme.save
    render(:partial => 'statement', :locals => {:statement =>
    statement, :remove => "approve_form#{disert_theme.id}"})
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
