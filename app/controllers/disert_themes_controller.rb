require 'leader'
class DisertThemesController < ApplicationController
  model :user
  model :tutor
  model :leader
  model :dean
include LoginSystem
  layout 'employers'
  before_filter :login_required, :prepare_student, :prepare_user
  # page for adding methodology to disert theme
  def methodology
    disert_theme = DisertTheme.find(@params['id'])
  end
  # upload methodology form
  def upload_methodology
    @title = _("Upload methodology") 
    @disert_theme = DisertTheme.find(@params['id'])
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
    @statement = disert_theme.index.statement_for(@user.person) 
    render_partial("shared/approve", :approvement => disert_theme.approvement, :title =>
    _("atestation"), :options => [[_("approve"), 1], [_("cancel"), 0]])
  end
  # confirms and saves statement
  def confirm_approve
    disert_theme = DisertTheme.find(@params['id'])
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
    render(:partial => 'shared/show', :locals => {:remove =>
    "approve_form#{disert_theme.index.study_plan.id}", :study_plan => disert_theme.index.study_plan})
  end
  def file_clicked
    disert_theme = DisertTheme.find(@params['id'])
    @statement = disert_theme.index.statement_for(@user.person)
    render(:partial => 'file_clicked', :locals => {:disert_theme =>
    disert_theme})
  end
end
