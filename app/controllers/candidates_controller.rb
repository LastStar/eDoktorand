class CandidatesController < ApplicationController
  model :candidate
  model :user
  include LoginSystem
  layout 'employers'
  before_filter :login_required
  # lists all candidates
  def index
    list
    render_action 'list'
  end
  # lists all candidates
  def list
    @pages, @candidates = paginate :candidates, :per_page => 5, :order_by => 'finished_on', :conditions => 'finished_on IS NOT NULL'
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
    @candidate = Candidate.find(@params['id'])
  end
  # confirms admition of student
  def confirm_admit
    @candidate = Candidate.find(@params['id'])
    @candidate.admit!
    flash['notice'] = 'Uchazeč byl úspěšně přijat.'
    redirect_to :action => 'list'
  end
end
