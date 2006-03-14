class ParametersController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @parameter_pages, @parameters = paginate :parameters, :per_page => 10
  end

  def show
    @parameter = Parameter.find(params[:id])
  end

  def new
    @parameter = Parameter.new
  end

  def create
    @parameter = Parameter.new(params[:parameter])
    if @parameter.save
      flash[:notice] = 'Parameter was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @parameter = Parameter.find(params[:id])
  end

  def update
    @parameter = Parameter.find(params[:id])
    if @parameter.update_attributes(params[:parameter])
      flash[:notice] = 'Parameter was successfully updated.'
      redirect_to :action => 'show', :id => @parameter
    else
      render :action => 'edit'
    end
  end

  def destroy
    Parameter.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
