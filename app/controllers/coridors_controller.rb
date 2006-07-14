class CoridorsController < ApplicationController
  include LoginSystem
  
  before_filter :login_required, :except => [:invitation]
  
  def index
    list
    render_action 'list'
  end

  def list
    @coridors = Coridor.find_all
  end

  def show
    @coridor = Coridor.find(@params['id'])
  end

  def new
    @coridor = Coridor.new
  end

  def create
    @coridor = Coridor.new(@params['coridor'])
    if @coridor.save
      flash['notice'] = 'Coridor was successfully created.'
      redirect_to :action => 'list'
    else
      render_action 'new'
    end
  end

  def edit
    @coridor = Coridor.find(@params['id'])
  end

  def update
    @coridor = Coridor.find(@params['coridor']['id'])
    if @coridor.update_attributes(@params['coridor'])
      flash['notice'] = 'Coridor was successfully updated.'
      redirect_to :action => 'show', :id => @coridor.id
    else
      render_action 'edit'
    end
  end

  def destroy
    Coridor.find(@params['id']).destroy
    redirect_to :action => 'list'
  end
end
