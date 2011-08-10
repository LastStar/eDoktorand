class FinalExamTermsController < ApplicationController
  layout 'employers'
  include LoginSystem
  helper :exam_terms, :students

  before_filter :login_required, :prepare_user

  # shows list of all defenses in system for user
  def list
    @title = t(:message_0, :scope => [:txt, :controller, :terms])
    @final_exam_terms = FinalExamTerm.find_for(@user,
                                               :future => params[:future],
                                               :not_passed => true)
  end

  def prepare_print
    if params[:terms] && !params[:terms].empty?
      @final_exam_terms = FinalExamTerm.find(params[:terms])
    else
      redirect_to :action => :list
    end
  end

  def claim
    @title = t(:message_1, :scope => [:txt, :controller, :terms])
    @study_plan = @user.person.index.study_plan
  end

  def confirm_claim
    index = @user.person.index
    @study_plan = index.study_plan
    if @study_plan.update_attributes(params[:study_plan])
      index.claim_final_exam!
      if (literature_review = params[:literature_review_file]) &&
        literature_review.is_a?(Tempfile)
        index.disert_theme.save_literature_review(literature_review)
      end
      index.disert_theme.update_attributes(params[:disert_theme])
      redirect_to :controller => :study_plans, :action => :index
    else
      @title = t(:message_1, :scope => [:txt, :controller, :terms])
      render :action => 'claim'
    end
  end

   def new
    @title = t(:message_2, :scope => [:txt, :controller, :terms])
    @tutors = Tutor.find_for(@user)
    index = Index.find(params[:id])
    if index.final_exam_term
      @final_exam_term = index.final_exam_term
      @tutors << Tutor.external_chairman
    else
      @final_exam_term = FinalExamTerm.new
      @final_exam_term.index = index
    end
  end

  def create
    if @final_exam_term = FinalExamTerm.find_by_index_id(params[:final_exam_term][:index_id])
      @final_exam_term.update_attributes(params[:final_exam_term])
    else
      @final_exam_term = FinalExamTerm.new(params[:final_exam_term])
    end
    @final_exam_term.detect_external_chairman(params[:external_chairman])
    if @final_exam_term.save
      flash['notice'] = t(:message_3, :scope => [:txt, :controller, :terms])
      redirect_to :action => :list
    else
      @tutors = Tutor.find_for(@user)
      render(:action => :new)
    end
  end

  def show
    @exam_term = FinalExamTerm.find(params[:id])
  end

  def edit
    @tutors = Tutor.find_for(@user)
    @tutors << Tutor.external_chairman
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
    if params[:mail]
      Notifications::deliver_invite_to_final_exam(@index)
    end
  end

  # prints protocol for final exam term
  def protocol
    @term = FinalExamTerm.find(params[:id])
  end

  def pass
    @date = Date.today
    @final_exam_term = Index.find(params[:id]).final_exam_term
  end

  def save_pass
    @final_exam_term = FinalExamTerm.find(params[:id])
    @final_exam_term.update_attributes(:questions => params[:questions], :discussion => params[:discussion])
    date = params[:date]
    date = Date.civil(date['year'].to_i, date['month'].to_i, date['day'].to_i)
    @final_exam_term.index.final_exam_passed!(date)
    redirect_to :action => :list
  end
end
