class FinalExamTermsController < ApplicationController
  layout 'employers'
  include LoginSystem
  helper :exam_terms

  before_filter :login_required, :prepare_user

  def list
    @title = _('Final exam terms')
    @final_exam_terms = FinalExamTerm.find_for(@user, :future => true)
  end

  def prepare_print
    @final_exam_terms = FinalExamTerm.find(params[:terms])
  end

  def claim
    @title = 'Final exam application'
    @study_plan = @user.person.index.study_plan
  end

  def confirm_claim
    index = @user.person.index
    index.claim_final_exam!(params[:study_plan][:final_areas])
    if params[:literature_review_file]
      index.disert_theme.save_literature_review(params[:literature_review_file])
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
    @exam_term = FinalExamTerm.new(params[:exam_term])
    tmp = FinalExamTerm.find_by_index_id(@exam_term.index.id)
    if tmp
      @exam_term = tmp
      @exam_term.update_attributes(params[:exam_term])
    end 
    if @exam_term.save
      flash['notice'] = 'Komise byla úspěšně vytvořena.'
      render_action :show
    else
      render_action :new
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

  def send_invitation
    @index = Index.find(params[:id])
    @index.send_final_exam_invitation!
    Notifications::deliver_invite_to_final_exam(@index)
  end

  def protocol
    @term = FinalExamTerm.find(params[:id])
  end
end
