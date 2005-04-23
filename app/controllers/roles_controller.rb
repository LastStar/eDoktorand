class RolesController < ApplicationController
  def index
    list
    render_action 'list'
  end

  def list
    @role_pages, @roles = paginate :role, :per_page => 10
  end

  def show
    @role = Role.find(@params[:id])
  end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new(@params[:role])
    if @role.save
      flash['notice'] = 'Role was successfully created.'
      redirect_to :action => 'list'
    else
      render_action 'new'
    end
  end

  def edit
    @role = Role.find(@params[:id])
  end

  def update
    @role = Role.find(@params[:id])
    if @role.update_attributes(@params[:role])
      flash['notice'] = 'Role was successfully updated.'
      redirect_to :action => 'show', :id => @role
    else
      render_action 'edit'
    end
  end

  def destroy
    Role.find(@params[:id]).destroy
    redirect_to :action => 'list'
  end
end
