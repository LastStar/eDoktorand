class DisertThemesController < ApplicationController
include LoginSystem
helper :disert_themes
  layout 'employers', :except => [:add_en, :save_en, :edit_title, :update_title]
  before_filter :login_required, :prepare_student, :prepare_user

  # edit cz title
  def edit_title
    @disert_theme = DisertTheme.find(params[:id])
  end

  # update title cz
  def update_title
    @disert_theme = DisertTheme.find(params[:disert_theme])
    @disert_theme.update_attribute(:title, params[:title])
  end

  # page for adding methodology to disert theme
  def methodology
    disert_theme = DisertTheme.find(params[:id])
  end

  # upload methodology form
  def upload_methodology
    @title = t(:message_0, :scope => [:controller, :themes])
    @disert_theme = DisertTheme.find(params[:id])
  end

  # saves methogology file
  def save_methodology
    @disert_theme = DisertTheme.find(params[:disert_theme][:id])
    if (file = params[:disert_theme][:methodology_file]).is_a? Tempfile
      DisertTheme.save_methodology(@disert_theme, file)
      render :text => "<script>window.close()</script>"
    else
      @title = t(:message_1, :scope => [:controller, :themes])
      flash.now[:error] = t(:message_2, :scope => [:controller, :themes])
      render :action => :upload_methodology
    end
  end

  # add disert theme english title
  def add_en
    @disert_theme = DisertTheme.find(params[:disert_theme])
  end

  #saving only disert_themes en (fixing bug)
  def save_en
    @disert_theme = DisertTheme.find(params[:disert_theme][:id])
    @disert_theme.update_attribute(:title_en, params[:disert_theme][:title_en])
  end

  def plagiat
    @disert_theme = DisertTheme.find(params[:id])
    @theses_results = @disert_theme.theses_results
  end

  def theses_result
    @theses_result = ThesesResult.find(params[:id])
    extend DisertThemes::Checker
    send_file download_theses_file(@theses_result)
  end

  def update_literature_review
    @disert_theme = DisertTheme.find(params[:id])
    if ((literature_review = params[:literature_review_file]) &&
      literature_review.is_a?(Tempfile))
      @disert_theme.save_literature_review(literature_review)
    end
    redirect_to :controller => :students
  end

  def update_self_report
    @disert_theme = DisertTheme.find(params[:id])
    if (self_report = params[:self_report_file]) && self_report.is_a?(Tempfile)
      @disert_theme.save_self_report_file(self_report)
    end
    redirect_to :controller => :students
  end

  def update_disert_theme
    @disert_theme = DisertTheme.find(params[:id])
    if (disert_theme = params[:disert_theme_file]) && disert_theme.is_a?(Tempfile)
      @disert_theme.save_disert_theme_file(disert_theme)
    end
    redirect_to :controller => :students
  end
end
