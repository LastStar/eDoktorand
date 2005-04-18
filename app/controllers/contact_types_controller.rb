class ContactTypesController < ApplicationController
  def index
    list
    render_action 'list'
  end

  def list
    @contact_types = ContactType.find_all
  end

  def show
    @contact_type = ContactType.find(@params[:id])
  end

  def new
    @contact_type = ContactType.new
  end

  def create
    @contact_type = ContactType.new(@params[:contact_type])
    if @contact_type.save
      flash['notice'] = 'ContactType was successfully created.'
      redirect_to :action => 'list'
    else
      render_action 'new'
    end
  end

  def edit
    @contact_type = ContactType.find(@params[:id])
  end

  def update
    @contact_type = ContactType.find(@params[:id])
    if @contact_type.update_attributes(@params[:contact_type])
      flash['notice'] = 'ContactType was successfully updated.'
      redirect_to :action => 'show', :id => @contact_type
    else
      render_action 'edit'
    end
  end

  def destroy
    ContactType.find(@params[:id]).destroy
    redirect_to :action => 'list'
  end
end
