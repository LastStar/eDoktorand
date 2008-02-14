class DisertThemesController < ApplicationController
include LoginSystem
  layout 'employers', :except => [:add_en, :save_en]
  before_filter :login_required, :prepare_student, :prepare_user
  
  # page for adding methodology to disert theme
  def methodology
    disert_theme = DisertTheme.find(params[:id])
  end
  
  # upload methodology form
  def upload_methodology
    @title = _("Upload methodology") 
    @disert_theme = DisertTheme.find(params[:id])
  end
  
  # saves methogology file
  def save_methodology
    @disert_theme = DisertTheme.find(params[:disert_theme][:id])
    unless params[:disert_theme][:methodology_file].empty?
      DisertTheme.save(params[:disert_theme])
      @disert_theme.update_attribute('methodology_added_on', Time.now)
      redirect_to(:action => 'index', :controller => 'study_plans')
    else
      @title = _("Upload methodology") 
      flash.now[:error] = _('Methodology file must be choosed')
      render :action => :upload_methodology
    end
  end
  
  def file_clicked
    @disert_theme = DisertTheme.find(params[:id])
  end

  #adding only disaer_themes en (fixing bug)
  def add_en
    @disert_theme = DisertTheme.find(params[:disert_theme])
  end

  #saving only disert_themes en (fixing bug)
  def save_en
    @disert_theme = DisertTheme.find(params[:disert_theme])
    @disert_theme.update_attribute(:title_en, params[:en_title])
  end
  
end
