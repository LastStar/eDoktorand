class AddressTypesController < ApplicationController
  def index
    list
    render_action 'list'
  end

  def list
    @address_types = AddressType.find_all
  end

  def show
    @address_type = AddressType.find(@params[:id])
  end

  def new
    @address_type = AddressType.new
  end

  def create
    @address_type = AddressType.new(@params[:address_type])
    if @address_type.save
      flash['notice'] = 'AddressType was successfully created.'
      redirect_to :action => 'list'
    else
      render_action 'new'
    end
  end

  def edit
    @address_type = AddressType.find(@params[:id])
  end

  def update
    @address_type = AddressType.find(@params[:id])
    if @address_type.update_attributes(@params[:address_type])
      flash['notice'] = 'AddressType was successfully updated.'
      redirect_to :action => 'show', :id => @address_type
    else
      render_action 'edit'
    end
  end

  def destroy
    AddressType.find(@params[:id]).destroy
    redirect_to :action => 'list'
  end
end
