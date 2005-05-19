class AdmitancesController < ApplicationController
  def index
    list
    render_action 'list'
  end

  def list
    @admitance_pages, @admitances = paginate :admitance, :per_page => 10
  end

  def show
    @admitance = Admitance.find(@params[:id])
  end

  def new
    @admitance = Admitance.new
  end

  def create
    @admitance = Admitance.new(@params[:admitance])
    if @admitance.save
      flash['notice'] = 'Admitance was successfully created.'
      redirect_to :action => 'list'
    else
      render_action 'new'
    end
  end

  def edit
    @admitance = Admitance.find(@params[:id])
  end

  def update
    @admitance = Admitance.find(@params[:id])
    if @admitance.update_attributes(@params[:admitance])
      flash['notice'] = 'Admitance was successfully updated.'
      redirect_to :action => 'show', :id => @admitance
    else
      render_action 'edit'
    end
  end

  def destroy
    Admitance.find(@params[:id]).destroy
    redirect_to :action => 'list'
  end
end
