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
end
