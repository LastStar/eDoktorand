class AddressesController < ApplicationController
  include LoginSystem
  layout "employers", :except => [:save, :save_street, :save_city, :save_zip, :save_desc_number, :edit_street, :edit_zip, :edit_city, :edit_desc_number]
  before_filter :set_title
  before_filter :login_required
  before_filter :prepare_student
  before_filter :prepare_user

  def edit_street
    @address = Address.find(params[:id])
  end

  def edit_city
    @address = Address.find(params[:id])
  end

  def edit_desc_number
    @address = Address.find(params[:id])
  end

  def edit_zip
    @address = Address.find(params[:id])
  end

  def edit
    student = @user.person
    @email = student.email ? student.email : Contact.new('contact_type_id' =>
      '1', 'person_id' => student.id)
    @phone = student.phone ? student.phone : Contact.new('contact_type_id' => '2', 'person_id' => student.id)
    @address = student.address ? student.address : Address.new('address_type_id' => '1', 'student_id' => student.id)
    @student = student
    @action = 'save'
    #render :action => 'edit'
  end
  
  # saves the contacts to dbase
  def save
    @student = Student.find(params[:address][:student_id])
    #first the email
    @student.email = Contact.create(params[:email])
    @student.phone = Contact.create(params[:phone])

    # and address
    if @student.address
      @student.address = Address.create(params[:address])
      @student.address.save
    else
      address = Address.new(params[:address])
      address.student = @student
      address.save
    end
    @student.citizenship = params[:student][:citizenship]
    @student.save
    #redirect_to :controller => 'study_plans'
  end

  # saves the street of address to db 
  def save_street
    if @student
      @address = Address.find(@student.address.id) 
    else
      @address = Address.find(params[:address][:id])
    end
    @address.update_attributes(params[:address])
  end
  
  # saves the city of address to db
  def save_city
    if @student
      @address = Address.find(@student.address.id) 
    else
      @address = Address.find(params[:address][:id])
    end
    @address.update_attributes(params[:address])
  end
  
  # saves the zip of address to db
  def save_zip
    if @student
      @address = Address.find(@student.address.id) 
    else
      @address = Address.find(params[:address][:id])
    end
    @address.update_attributes(params[:address])
  end

  # saves the description number of address to db
  def save_desc_number
    if @student
      @address = Address.find(@student.address.id) 
    else
      @address = Address.find(params[:address][:id])
    end
    @address.update_attributes(params[:address])
  end

  # sets title of the controller
  def set_title
    @title = t(:message_0, :scope => [:txt, :controller, :addresses])
  end
end
