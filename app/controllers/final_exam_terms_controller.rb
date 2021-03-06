class FinalExamTermsController < ApplicationController
  layout 'employers'
  include LoginSystem
  helper :exam_terms, :students

  before_filter :login_required, :except => :prepare_print
  before_filter :prepare_user, :prepare_student

  def list
    @title = t(:message_0, :scope => [:controller, :terms])
    @final_exam_terms = FinalExamTerm.find_for(@user,
                                               :future => params[:future],
                                               :not_passed => true)
  end

  def prepare_print
    if params[:terms] && !params[:terms].empty?
      @final_exam_terms = FinalExamTerm.find(params[:terms])
      @faculty = @final_exam_terms.first.index.faculty
    else
      redirect_to :action => :list
    end
  end

  def claim
    @title = t(:claim, :scope => [:controller, :terms])
    @study_plan = @user.person.index.study_plan
  end

  #TODO if ever gets to refactoring do all this saving with carrierwave
  #GOD BLESS
  def confirm_claim
    index = @user.person.index
    @study_plan = index.study_plan
    both = params.delete(:both_in_one_day)
    if ((literature_review = params[:literature_review_file]) &&
      literature_review.is_a?(Tempfile)) || both
      if @study_plan.update_attributes(params[:study_plan])
        index.claim_final_exam!
        Notifications::deliver_claimed_final_exam(index)
        if both
          redirect_to :controller => :defenses, :action => :claim
        else
          index.disert_theme.save_literature_review(literature_review)
          index.disert_theme.update_attributes(params[:disert_theme])
          redirect_to :controller => :study_plans, :action => :index
        end
      else
        @title = t(:message_1, :scope => [:controller, :terms])
        render :action => 'claim'
      end
    else
      @title = t(:message_1, :scope => [:controller, :terms])
      @study_plan.errors.add_to_base t(:review_required, :scope => [:controller, :terms])
      render :action => 'claim'
    end
  end

   def new
    @title = t(:message_2, :scope => [:controller, :terms])
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
    if @final_exam_term = Index.find(params[:final_exam_term][:index_id]).final_exam_term
      @final_exam_term.update_attributes(params[:final_exam_term])
    else
      @final_exam_term = FinalExamTerm.new(params[:final_exam_term])
    end
    @final_exam_term.detect_external_chairman(params[:has_external_chairman])
    if @final_exam_term.save
      flash['notice'] = t(:message_3, :scope => [:controller, :terms])
      redirect_to :action => :list
    else
      @tutors = Tutor.find_for(@user)
      render(:action => :new)
    end
  end

  def show
    @title = t(:term, :scope => [:controller, :final_exam_terms])
    @final_exam_term = FinalExamTerm.find(params[:id])
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
    redirect_to :action => :list
  end

  # prints protocol for final exam term
  def protocol
    @term = FinalExamTerm.find(params[:id])
  end

  def pass
    @title = t(:passing, :scope => [:controller, :final_exam_terms])
    @date = Date.today
    @final_exam_term = Index.find(params[:id]).final_exam_term
  end

  def save_pass
    @final_exam_term = FinalExamTerm.find(params[:id])
    @final_exam_term.update_attributes(:questions => params[:questions], :discussion => params[:discussion])
    date = params[:date]
    date = Date.civil(date['year'].to_i, date['month'].to_i, date['day'].to_i)
    if params[:commit] == t(:not_passed, :scope => [:view, :final_exam_terms, :pass])
      @final_exam_term.not_passed!(date)
      @final_exam_term.index.final_exam_not_passed!
    else
      @final_exam_term.index.final_exam_passed!(date)
    end
    redirect_to :action => :list
  end
end
