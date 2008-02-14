class FinalExamTermsController < ApplicationController
  layout 'employers'
  include LoginSystem
  helper :exam_terms

  before_filter :login_required, :prepare_user

  # shows list of all defenses in system for user
  def list
    @title = _('Final exam terms')
    @final_exam_terms = FinalExamTerm.find_for(@user, :future => params[:future])
  end

  def prepare_print
    if params[:terms] && !params[:terms].empty?
      @final_exam_terms = FinalExamTerm.find(params[:terms])
    else
      redirect_to :action => :list
    end
  end

  def claim
    @title = _('Final exam application')
    @study_plan = @user.person.index.study_plan
  end

  def confirm_claim
    index = @user.person.index
    index.claim_final_exam!(params[:study_plan][:final_areas])
    if (literature_review = params[:literature_review_file]) &&
      literature_review.is_a?(Tempfile)
      index.disert_theme.save_literature_review(literature_review)
    end
    index.disert_theme.update_attributes(params[:disert_theme])
    redirect_to :controller => :study_plans, :action => :index
  end

  def new
    @title = _('Creating final exam term')
    index = Index.find(params[:id]) 
    if index.final_exam_term
      @exam_term = index.final_exam_term
    else
      @exam_term = FinalExamTerm.new
      @exam_term.index = index
    end
  end

  def create
    if @exam_term = FinalExamTerm.find_by_index_id(params[:exam_term][:index_id])
      @exam_term.update_attributes(params[:exam_term])
    else
      @exam_term = FinalExamTerm.new(params[:exam_term])
    end 
    if @exam_term.save
      flash['notice'] = _('final exam term was succesfully created')
      render(:action => :show)
    else
      render(:action => :new)
    end
  end

  def show
    @exam_term = FinalExamTerm.find(params[:id])
  end

  def edit
    @exam_term = FinalExamTerm.find(params[:id])
  end

  def destroy
    FinalExamTerm.find(params[:id]).destroy
    redirect_to :action => 'list' #TODO render proper action
  end

  # sends invitation to final exam
  def send_invitation
    @index = Index.find(params[:id])
    @index.send_final_exam_invitation!
    Notifications::deliver_invite_to_final_exam(@index)
  end

  # prints protocol for final exam term
  def protocol
    @term = FinalExamTerm.find(params[:id])
  end
end
