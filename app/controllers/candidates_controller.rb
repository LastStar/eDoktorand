class CandidatesController < ApplicationController
  model :candidate
  model :user
  include LoginSystem
  layout 'employers'
  before_filter :login_required, :except => [:invitation]
  before_filter :set_title, :change_sort
  # lists all candidates
  def index
    list
    render_action 'list'
  end
  # lists all candidates
  def list
	 @filtered_by = @params['filter'] 
		conditions = 'finished_on IS NOT NULL'
		conditions << case @params['filter']
                  when 'unready':' AND finished_on IS NOT NULL AND ready_on IS
                    NULL'
									when 'ready': ' AND ready_on IS NOT NULL AND invited_on IS NULL'
									when 'invited': ' AND invited_on IS NOT NULL AND admited_on IS NULL'
									when 'admited': ' AND admited_on IS NOT NULL AND enrolled_on IS NULL'
									when 'enrolled': ' AND enrolled_on IS NOT NULL'
									when nil: ''
									end
		conditions << " AND coridor_id = #{@params['coridor']}" if @params['coridor']
    @pages, @candidates = paginate :candidates, :per_page => 7, :order_by => @params['category'], :conditions => conditions
  end
  # lists all candidates ordered by category
  def list_all
	  @candidates = Candidate.find(:all, :order => @params['category'],
	  :conditions => 'finished_on IS NOT NULL')
	  render_action 'list'
  end
  # shows candidate details
  def show
    @candidate = Candidate.find(@params['id'])
  end
  # edits candidate
  def edit
    @candidate = Candidate.find(@params['id'])
    @action = 'update'
  end
  # updates candidate
  def update
    @candidate = Candidate.find(@params['candidate']['id'])
    if @candidate.update_attributes(@params['candidate'])
      flash['notice'] = _('Candidate was changed')
      redirect_to :action => 'show', :id => @candidate.id
    else
      render_action 'edit'
    end
  end
  # destroys candidate
  def destroy
    Candidate.find(@params['id']).destroy
    redirect_to :action => 'list'
  end
  # enroll candidate form
  def enroll
		@candidate = Candidate.find(@params['id'])
		@user = User.new
  end
	# confirms enrollment of candidate and sends email
  def confirm_enroll
    @candidate = Candidate.find(@params['id'])
    # Notifications::deliver_admit_candidate(@candidate)
    @candidate.enroll!
    if !@params['user']['login'].empty?
      @user = User.new(@params['user'])
      @user.person = @candidate.student
      @user.roles << Role.find_by_name('student')
      if !@user.save
        render_action 'enroll'
      end  
    end
    redirect_to :action => 'list'
  end
  # amits candidate form
  def admit
		@candidate = Candidate.find(@params['id'])
  end
	# confirms admittance of candidate and sends email
	def confirm_admit
		@candidate = Candidate.find(@params['id'])
		@candidate.update_attributes(@params['candidate'])
	end
	# action for remote link that invite candidate
	def admit_now
		@candidate = Candidate.find(@params['id'])
		Notifications::deliver_admit_candidate(@candidate)
		@candidate.admit!
		render_text _('e-mail sent')
	end
	
	# finishes admittance
	def admittance
		@candidate = Candidate.find(@params['id'])
	end
  # set candidate ready for invitation
  def ready
    candidate = Candidate.find(@params['id'])
    candidate.ready!
    flash['notice'] = _("Candidate ") + candidate.display_name + _(" is ready for application form")
    redirect_to :action => 'list'
  end
  # set candidate ready for admition
  def invite
    @candidate = Candidate.find(@params['id'])
    render_action 'invitation'
  end
	# action for remote link that invite candidate
	def invite_now
		@candidate = Candidate.find(@params['id'])
    @candidate.invite!
		Notifications::deliver_invite_candidate(@candidate)
		render_text _('e-mail sent')
	end
	# shows invitation for candidate
	def invitation
		@candidate = Candidate.find(@params['id'])
	end

  # summary method for candidates
  def summary
    if @params["id"] == "department" || @params["id"].empty?
      @departments = Department.find(:all)
    else
      @corridors = Coridor.find(:all)
    end
  end
  
  private
  # sets title of the controller
  def set_title
    @title = _('Candidates')
  end
  # changes sorting
  def change_sort
		@params['page'] = '1' unless @params['page'] # cause nil page means first :-)
		if @session['page'] == @params['page']
	    if @params['category'] == @session['category']
        @session['order'] = @session['order'] == ' desc' ? '' : ' desc'
	    else
	      @session['order'] = ''
	    end
	    @session['category'] = @params['category']
	    @params['category'] << @session['order'] if @params['category'] 
		else
			@session['page'] = @params['page']
		end
  end
end
