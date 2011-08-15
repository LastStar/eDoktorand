class DefensesController < ApplicationController
  layout 'employers'
  include LoginSystem
  helper :exam_terms

  before_filter :login_required, :prepare_user, :prepare_student

  # page for student defense claim
  def claim
    @title = t(:message_0, :scope => [:controller, :defenses])
  end

  # confirm defense claim and redirect to study plan
  # on error return to claim page
  def confirm_claim
    index = @user.person.index
    disert_theme = index.disert_theme
    if (self_report = params[:self_report_file]) && self_report.is_a?(Tempfile) &&
      (theme = params[:disert_theme_file]) && theme.is_a?(Tempfile)
      index.disert_theme.save_self_report_file(self_report)
      index.disert_theme.save_theme_file(theme)
      index.claim_defense!
      redirect_to :controller => :study_plans, :action => :index
    else
      flash[:error] = t(:message_1, :scope => [:controller, :defenses])
      redirect_to :action => :claim
    end
  end

  # page with defense form
  def new
    index = Index.find(params[:id])
    unless @defense = index.defense
      @defense = Defense.new
      @defense.index = index
    end
  end

  # created defense term
  def create
    if @defense = Defense.find_by_index_id(params[:defense][:index_id])
      @defense.update_attributes(params[:defense])
    else
      @defense = Defense.new(params[:defense])
    end
    if @defense.save
      flash['notice'] = t(:message_2, :scope => [:controller, :defenses])
      render(:action => :show)
    else
      render(:action => :new)
    end
  end

  # marks defense term as emailed and sends email to student
  def send_invitation
    @index = Index.find(params[:id])
    @index.send_defense_invitation!
    if params[:mail] != 'no mail'
      Notifications::deliver_invite_to_defense(@index)
    end
    redirect_to :action => :list
  end

  #shows defense term in study plan
  def show
    @defense = Defense.find(params[:id])
  end

  # shows list of all defenses in system for user
  def list
    @title = t(:message_3, :scope => [:controller, :defenses])
    @defenses = Defense.find_for(@user, :not_passed => true)
  end

  # prints of announcement of defense
  def announcement
    @title = t(:message_4, :scope => [:controller, :defenses])
    @defense = Defense.find(params[:id])
  end

  # prints protocol for defense
  def protocol
    @title = t(:message_5, :scope => [:controller, :defenses])
    @defense = Defense.find(params[:id])
  end

  def pass
    @title = t(:passing, :scope => [:controller, :defenses])
    @date = Date.today
    @defense = Index.find(params[:id]).defense
  end

  def save_pass
    @defense = Defense.find(params[:id])
    @defense.update_attributes(:questions => params[:questions], :discussion => params[:discussion])
    date = params[:date]
    date = Date.civil(date['year'].to_i, date['month'].to_i, date['day'].to_i)
    @defense.index.final_exam_passed!(date)
    redirect_to :action => :list
  end
end
