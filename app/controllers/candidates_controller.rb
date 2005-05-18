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
		conditions << " AND #{@params['filter']}_on NOT NULL" if @params['filter']
		conditions << " AND coridor_id = #{@params['coridor']}" if @params['coridor']
    @pages, @candidates = paginate :candidates, :per_page => 7, :order_by => @params['category'], :conditions => conditions
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
  # amits candidate
  def admit
  	candidate = Candidate.find(@params['id'])
  	candidate.admit!
  	flash['notice'] = 'Uchazeč byl úspěšně přijat.'
  	redirect_to :action => 'list'
  end
  # set candidate ready for admition
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
    if @params['category'] == @session['category']
      @session['order'] = @session['order'] == ' desc' ? '' : ' desc'
    else
      @session['order'] = ''
    end
    @session['category'] = @params['category']
    @params['category'] += @session['order'] if @params['category']
  end
end
