class StudiesController < ApplicationController
  def index
    list
    render_action 'list'
  end

  def list
    @studies = Study.find_all
  end

  def show
    @study = Study.find(@params['id'])
  end

  def new
    @study = Study.new
  end

  def create
    @study = Study.new(@params['study'])
    if @study.save
      flash['notice'] = 'Study was successfully created.'
      redirect_to :action => 'list'
    else
      render_action 'new'
    end
  end

  def edit
    @study = Study.find(@params['id'])
  end

  def update
    @study = Study.find(@params['study']['id'])
    if @study.update_attributes(@params['study'])
      flash['notice'] = 'Study was successfully updated.'
      redirect_to :action => 'show', :id => @study.id
    else
      render_action 'edit'
    end
  end

  def destroy
    Study.find(@params['id']).destroy
    redirect_to :action => 'list'
  end
end
