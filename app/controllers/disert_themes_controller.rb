class DisertThemesController < ApplicationController
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
  def file_clicked
    disert_theme = DisertTheme.find(@params['id'])
    render(:partial => 'file_clicked', :locals => {:disert_theme =>
      disert_theme})
  end
end
