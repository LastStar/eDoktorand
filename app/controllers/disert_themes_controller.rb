class DisertThemesController < ApplicationController
include LoginSystem
  layout 'employers', :except => [:add_en, :save_en]
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

  #adding only disaer_themes en (fixing bug)
  def add_en
    @disert_theme = DisertTheme.find(params[:disert_theme])
  end

  #saving only disert_themes en (fixing bug)
  def save_en
    @disert_theme = DisertTheme.find(params[:disert_theme])
    @disert_theme.title_en = params[:en_title]
    @disert_theme.save
  end
  
end
