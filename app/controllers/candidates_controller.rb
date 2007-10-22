class CandidatesController < ApplicationController
  include LoginSystem
  layout 'employers'

  before_filter :login_required, :except => [:invitation]
  before_filter :prepare_user
  before_filter :prepare_faculty
  before_filter :set_title
  before_filter :prepare_sort, :only => [:list, :list_all]


  # lists all candidates
  def index
    if @user.has_role?('board_chairman')
      redirect_to :action => 'list_admission_ready', :coridor => @user.person.tutorship.coridor_id
    else
      list
      render_action 'list'
    end
  end

  # lists all candidates
  def list
      @backward = false
      @filtered_by = params[:filter]
      session[:back_page] = 'list'
      conditions = Candidate.prepare_conditions(params, @faculty)
      @pages, @candidates = paginate :candidates, :per_page => 7, :order_by =>
        session[:category], :conditions => conditions
      session[:current_page_backward] = @pages.current.number
  end

  # lists all candidates ordered by category
  def list_all
    @backward = true
    session[:back_page] = 'list_all'
    @candidates = Candidate.find_all_finished_by_session_category(params, @faculty, session[:category])
    session[:current_page_backward_all] = session[:category]
    render_action 'list'
  end

  # lists all candidates ordered by category
  def list_admission_ready
    @candidates = Coridor.find(params[:coridor]).approved_candidates
    render_action 'list'
  end

  # shows candidate details
  def show
    @candidate = Candidate.find(params[:id])
  end

  # edits candidate
  def edit
    @candidate = Candidate.find(params[:id])
    @action = 'update'
  end

  # updates candidate
  def update
    @candidate = Candidate.find(params[:candidate][:id])
    if @candidate.update_attributes(params[:candidate])
      flash[:notice] = _('Candidate was changed')
      redirect_to :action => 'show', :id => @candidate.id
    else
      render_action 'edit'
    end
  end

  # destroys candidate
  def destroy
    Candidate.find(params[:id]).destroy
      if session[:back_page] == 'list'
        redirect_to :action => 'list', :page => session[:current_page_backward]
      else
        redirect_to :action => 'list_all'
      end

  end
  
  # delete candidate
  def delete
    Candidate.find(params[:id]).unfinish!
      if session[:back_page] == 'list'
        redirect_to :action => 'list', :page => session[:current_page_backward]
      else
        redirect_to :action => 'list_all'
      end
  end

  def admit_for_revocation
    candidate = Candidate.find(params[:id])
    candidate.delete_reject!
    candidate.admit!
      if session[:back_page] == 'list'
        redirect_to :action => 'list', :page => session[:current_page_backward]
      else
        redirect_to :action => 'list_all'
      end
  end
  # enroll candidate form
  def enroll
		@candidate = Candidate.find(params[:id])
		@user = User.new
  end

	# confirms enrollment of candidate and sends email
  def confirm_enroll
    @candidate = Candidate.find(params[:id])
    # Notifications::deliver_admit_candidate(@candidate)
    @candidate.enroll!
    if !params[:user][:login].empty?
      @user = User.new(params[:user])
      @user.person = @candidate.student
      @user.roles << Role.find_by_name('student')
      @user.person.index = Index.create('tutor_id' => @candidate.tutor_id,
      'department_id' => @candidate.department_id, 'study_id' => @candidate.study_id,
      'coridor_id' => @candidate.coridor_id)
      if !@user.save
        render_action 'enroll'
      else
        redirect_to :action => 'list'
      end  
    end
  end

  # amits candidate form
  def admit
    @candidate = Candidate.find(params[:id])
  end

  # confirms admittance of candidate and sends email
  def confirm_admit
    if(params[:admit_id] == '0')
      redirect_to(:action => 'reject', :id => params[:id])
    else
      session[:conditional] = @conditional = true if params[:admit_id] == '2'
      @candidate = Candidate.find(params[:id])
      @candidate.update_attributes(params[:candidate])
    end
  end

  # action for remote link that admit candidate
  def admit_now
    @candidate = Candidate.find(params[:id])
    Notifications::deliver_admit_candidate(@candidate, session[:conditional])
    @candidate.admit!
    render_text _('e-mail sent')
  end

  # finishes admittance
  def admittance
   @candidate = Candidate.find(params[:id])
  end

  # set candidate ready for invitation
  def ready
    candidate = Candidate.find(params[:id])
    candidate.ready!
    flash['notice'] = _("Candidate ") + candidate.display_name + _(" is ready for application form")
    if session[:back_page] == 'list'
      redirect_to :action => 'list', :page => session[:current_page_backward]
    else
      redirect_to :action => 'list_all'
    end
  end

  # set candidate ready for admition
  def invite
    @candidate = Candidate.find(params[:id])
    render_action 'invitation'
  end

	# action for remote link that invite candidate
  def invite_now
    @candidate = Candidate.find(params[:id])
    @candidate.invite!
    Notifications::deliver_invite_candidate(@candidate, @faculty, Time.now)
    render_text _('e-mail sent')
  end

  # shows invitation for candidate
  def invitation
   @candidate = Candidate.find(params[:id])
  end

  # rejects candidate from study
  def reject
    @candidate = Candidate.find(params[:id])
  end

  # action for remote link that reject candidate
  def reject_now
    @candidate = Candidate.find(params[:id])
    @candidate.reject!
		Notifications::deliver_reject_candidate(@candidate)
		render_text _('e-mail sent')
  end

  # summary method for candidates
  def summary
    faculty = Faculty.find(@user.person.faculty.id)
    if params[:id] == "department" || params[:id].empty?
       @departments = faculty.departments
     else
       @corridors = faculty.coridors
    end
  end
  
  private

  # sets title of the controller
  def set_title
    @title = _('Candidates')
  end

  def prepare_sort
      if params[:category] && params[:page] == nil
        session[:category] = params[:category]
        if params[:category] == session[:category]
            session[:order] = session[:order] == ' desc' ? '' : ' desc'
        else
	  session[:order] = ''
	end
        session[:category] << session[:order]
      end
  end
end
