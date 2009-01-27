class ExamTermsController < ApplicationController
  include LoginSystem
  layout 'employers'
  before_filter :login_required, :prepare_user
  before_filter :prepare_faculty, :only => [:list, :index]

  def index
    list
    render(:action => :list)
  end

  def list
    @title = t(:message_0, :scope => [:txt, :controller, :terms])
    @exam_terms = AdmissionTerm.find_for(@user)
  end

  def show
    @exam_term = AdmissionTerm.find(params[:id])
  end

  def new
    @title = 'Vytváření komise příjimacích zkoušek'
    @exam_term = AdmissionTerm.new
    @exam_term.coridor_id = params[:id] if params[:id]
  end

  def create
    @exam_term = AdmissionTerm.new(params[:exam_term])
    if @exam_term.save
      flash['notice'] = 'Komise byla úspěšně vytvořena.'
      if params[:from] && params[:from] == 'candidate'
        if session[:back_page] == 'list'
          redirect_to :action => 'list', :page => session[:current_page_backward] , :controller => 'candidates'
        else
          redirect_to :action => 'list_all', :controller => 'candidates'
        end
      else
        redirect_to :action => 'list'
      end
    else
      render(:action => 'new')
    end
  end

  def edit
    @exam_term = AdmissionTerm.find(params[:id])
  end

  def update
    @exam_term = AdmissionTerm.find(params[:id])
    if @exam_term.update_attributes(params[:exam_term])
      flash['notice'] = 'Komise byla úspěšně opravena'
      redirect_to :action => 'list'
    else
      render(:action => :edit)
    end
  end

  def destroy
    AdmissionTerm.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
