class ActualitiesController < ApplicationController
  include LoginSystem
  layout  'employers'
  uses_tiny_mce :options => {:theme => 'advanced', :theme_advanced_resizing => 'true', :width => 600, :height => 400, :language => 'cs' }
  before_filter :login_required
  
  def index
    list
    render :action => 'list'
  end

  def list
    @actualities = Actuality.paginate :page => params[:page]
  end

  def show
    @actuality = Actuality.find(params[:id])
  end

  def new
    @actuality = Actuality.new
  end

  def create
    @actuality = Actuality.new(params[:actuality])
    if @actuality.save
      flash[:notice] = 'Actuality was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @actuality = Actuality.find(params[:id])
  end

  def update
    @actuality = Actuality.find(params[:id])
    if @actuality.update_attributes(params[:actuality])
      flash[:notice] = 'Actuality was successfully updated.'
      redirect_to :action => 'show', :id => @actuality
    else
      render :action => 'edit'
    end
  end

  def destroy
    Actuality.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
