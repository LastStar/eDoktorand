class DefensesController < ApplicationController
  layout 'employers'
  include LoginSystem
  helper :exam_terms

  before_filter :login_required, :prepare_user

  # page for student defense claim
  def claim
    @title = _('Defense application')
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
      flash[:error] = _('You have to supply self report file')
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
      flash['notice'] = _('defense term was succesfully created')
      render(:action => :show)
    else
      render(:action => :new)
    end
  end

  # marks defense term as emailed and sends email to student
  def send_invitation
    @index = Index.find(params[:id])
    @index.send_defense_invitation!
    Notifications::deliver_invite_to_defense(@index)
  end

  #shows defense term in study plan
  def show
    @defense = Defense.find(params[:id])
  end

  # shows list of all defenses in system for user
  def list
    @title = _('Defense terms')
    @defenses = Defense.find_for(@user)
  end

  # prints of announcement of defense
  def announcement
    @title = _('Announcement of disert theme defense')
    @defense = Defense.find(params[:id])
  end

  # prints protocol for defense
  def protocol
    @title = _('Protocol for disert theme defense')
    @defense = Defense.find(params[:id])
  end
end
