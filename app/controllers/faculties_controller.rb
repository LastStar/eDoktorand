class FacultiesController < ApplicationController
  include LoginSystem
  
  before_filter :login_required, :except => [:ivitation]
  
  def index
    list
    render_action 'list'
  end

  def list
    @faculties = Faculty.find_all
  end

  def show
    @faculty = Faculty.find(params[:id])
  end

  def new
    @faculty = Faculty.new
  end

  def create
    @faculty = Faculty.new(params[:faculty])
    if @faculty.save
      flash['notice'] = 'Faculty was successfully created.'
      redirect_to :action => 'list'
    else
      render_action 'new'
    end
  end

  def edit
    @faculty = Faculty.find(params[:id])
  end

  def update
    @faculty = Faculty.find(params[:faculty][:id])
    if @faculty.update_attributes(params[:faculty])
      flash['notice'] = 'Faculty was successfully updated.'
      redirect_to :action => 'show', :id => @faculty.id
    else
      render_action 'edit'
    end
  end

  def destroy
    Faculty.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
