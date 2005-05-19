class AdmittancesController < ApplicationController
  def index
    list
    render_action 'list'
  end

  def list
    @admittance_pages, @admittances = paginate :admittance, :per_page => 10
  end

  def show
    @admittance = Admittance.find(@params[:id])
  end

  def new
    @admittance = Admittance.new
  end

  def create
    @admittance = Admittance.new(@params[:admittance])
    if @admittance.save
      flash['notice'] = 'Admittance was successfully created.'
      redirect_to :action => 'list'
    else
      render_action 'new'
    end
  end

  def edit
    @admittance = Admittance.find(@params[:id])
  end

  def update
    @admittance = Admittance.find(@params[:id])
    if @admittance.update_attributes(@params[:admittance])
      flash['notice'] = 'Admittance was successfully updated.'
      redirect_to :action => 'show', :id => @admittance
    else
      render_action 'edit'
    end
  end

  def destroy
    Admittance.find(@params[:id]).destroy
    redirect_to :action => 'list'
  end
end
