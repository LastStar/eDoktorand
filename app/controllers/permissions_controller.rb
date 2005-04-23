class PermissionsController < ApplicationController
  def index
    list
    render_action 'list'
  end

  def list
    @permission_pages, @permissions = paginate :permission, :per_page => 10
  end

  def show
    @permission = Permission.find(@params[:id])
  end

  def new
    @permission = Permission.new
  end

  def create
    @permission = Permission.new(@params[:permission])
    if @permission.save
      flash['notice'] = 'Permission was successfully created.'
      redirect_to :action => 'list'
    else
      render_action 'new'
    end
  end

  def edit
    @permission = Permission.find(@params[:id])
  end

  def update
    @permission = Permission.find(@params[:id])
    if @permission.update_attributes(@params[:permission])
      flash['notice'] = 'Permission was successfully updated.'
      redirect_to :action => 'show', :id => @permission
    else
      render_action 'edit'
    end
  end

  def destroy
    Permission.find(@params[:id]).destroy
    redirect_to :action => 'list'
  end
end
