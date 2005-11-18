class ActualitiesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @actuality_pages, @actualities = paginate :actualities, :per_page => 10
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
