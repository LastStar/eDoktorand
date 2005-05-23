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
		conditions = 'finished_on IS NOT NULL'
		conditions << case @params['filter']
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
		@candidates = Candidate.find(:all, :order_by => @params['category'])
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
      flash['notice'] = 'Uchazeč byl opraven'
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
  end
	# confirms enrollment of candidate and sends email
	def confirm_enroll
		@candidate = Candidate.find(@params['id'])
		# Notifications::deliver_admit_candidate(@candidate)
		@candidate.enroll!
    redirect_to :action => 'list'
	end
  # amits candidate form
  def admit
		@candidate = Candidate.find(@params['id'])
  end
	# confirms admittance of candidate and sends email
	def confirm_admit
		@candidate = Candidate.find(@params['id'])
		@candidate.tutor_id = @params['candidate']['tutor_id']
		Notifications::deliver_admit_candidate(@candidate)
		@candidate.admit!
	end
	# finishes admittance
	def admittance
		@candidate = Candidate.find(@params['id'])
	end
  # set candidate ready for invitation
  def ready
    candidate = Candidate.find(@params['id'])
    candidate.ready!
    flash['notice'] = "Uchazeč #{candidate.display_name} je připraven na příjimací zkoušky"
    redirect_to :action => 'list'
  end
  # set candidate ready for admition
  def invite
    @candidate = Candidate.find(@params['id'])
    @candidate.invite!
		Notifications::deliver_invite_candidate(@candidate)
    render_action 'invitation'
  end
	# shows invitation for candidate
	def invitation
		@candidate = Candidate.find(@params['id'])
	end

  private
  # sets title of the controller
  def set_title
    @title = 'Uchazeči o studium'
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
