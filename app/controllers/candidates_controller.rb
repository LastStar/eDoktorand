class CandidatesController < ApplicationController
  def index
    list
    render_action 'list'
  end

  def list
    @candidates = Candidate.find_all
  end

  def show
    @candidate = Candidate.find(@params['id'])
  end

  def new
    @candidate = Candidate.new
  end

  def create
    @candidate = Candidate.new(@params['candidate'])
    if @candidate.save
      flash['notice'] = 'Candidate was successfully created.'
      redirect_to :action => 'list'
    else
      render_action 'new'
    end
  end

  def edit
    @candidate = Candidate.find(@params['id'])
  end

  def update
    @candidate = Candidate.find(@params['candidate']['id'])
    if @candidate.update_attributes(@params['candidate'])
      flash['notice'] = 'Candidate was successfully updated.'
      redirect_to :action => 'show', :id => @candidate.id
    else
      render_action 'edit'
    end
  end

  def destroy
    Candidate.find(@params['id']).destroy
    redirect_to :action => 'list'
  end
end
