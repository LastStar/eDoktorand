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
    @title = t(:message_3, :scope => [:txt, :controller, :terms])
    @exam_terms = AdmissionTerm.find_for(@user)
  end

  def show
    @exam_term = AdmissionTerm.find(params[:id])
  end

  def new
    @title = t(:creation_commission, :scope => [:txt, :controller, :terms])
    @tutors = Tutor.find_for(@user)
    @exam_term = AdmissionTerm.new
    @exam_term.specialization_id = params[:id] if params[:id]
  end

   def create
      @exam_term = AdmissionTerm.new(params[:exam_term])
      @exam_term.detect_external_chairman(params[:external_chairman])  
    if @exam_term.save
      flash['notice'] = t(:commision_was_created, :scope => [:txt, :controller, :terms])
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
      @tutors = Tutor.find_for(@user)
      render(:action => 'new')
    end
  end

  def edit
    @tutors = Tutor.find_for(@user)
    @tutors << Tutor.external_chairman
    @exam_term = AdmissionTerm.find(params[:id])
  end

  def update
    @exam_term = AdmissionTerm.find(params[:id])
     
    if @exam_term.update_attributes(params[:exam_term])
      @exam_term.detect_external_chairman(params[:external_chairman])
      @exam_term.save
      flash['notice'] = t(:commision_was_updated, :scope => [:txt, :controller, :terms])
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
