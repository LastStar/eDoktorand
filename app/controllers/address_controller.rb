class AddressController < ApplicationController
  include LoginSystem
  layout "employers", :except => [:save, :save_street, :save_city, :save_zip, :save_desc_number]
  before_filter :set_title
  before_filter :login_required
  before_filter :prepare_student
  before_filter :prepare_user

  def edit_street
    @student ||= Student.find(params[:id])
    @address = @student.address_or_new
  end

  def edit_city
    @index = Index.find(@params['id'])
    student = @user.person
    @address = student.address ? student.address : Address.new('address_type_id' => '1', 'student_id' => student.id)
    @action = 'save_city'
  end

  def edit_desc_number
    student = @user.person
    @index = Index.find(@params['id'])
    @address = student.address ? student.address : Address.new('address_type_id' => '1', 'student_id' => student.id)
    @action = 'save_desc_number'
  end

  def edit_zip
    student = @user.person
    @index = Index.find(@params['id'])
    @address = student.address ? student.address : Address.new('address_type_id' => '1', 'student_id' => student.id)
    @action = 'save_zip'
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
    @student = Student.find(@params['address']['student_id'])
    #first the email
    @student.email = Contact.create(@params['email'])
    @student.phone = Contact.create(@params['phone'])

    # and address
    if @student.address
      @student.address = Address.create(@params['address'])
      @student.address.save
    else
      address = Address.new(@params['address'])
      address.student = @student
      address.save
    end
    @student.citizenship = @params['student']['citizenship']
    @student.save
    #redirect_to :controller => 'study_plans'
  end

  # saves the street of address to db 
  def save_street
    @index = Index.find(@params['id'])
    @address = @index.student.address || 
      Address.create_habitat_for(@index.student)
    @address.update_attributes(@params['address'])
  end
  
  # saves the city of address to db
  def save_city
    @index = Index.find(@params['id'])
    @address = @index.student.address || 
      Address.create_habitat_for(@index.student)
    @address.update_attributes(@params['address'])
  end
  
  # saves the zip of address to db
  def save_zip
    @index = Index.find(@params['id'])
    @address = @index.student.address || 
      Address.create_habitat_for(@index.student)
    @address.update_attributes(@params['address'])
  end

  # saves the description number of address to db
  def save_desc_number
    @index = Index.find(@params['id'])
    @address = @index.student.address || 
      Address.create_habitat_for(@index.student)
    @address.update_attributes(@params['address'])
  end

  # sets title of the controller
  def set_title
    @title = _('Contacts')
  end
end
