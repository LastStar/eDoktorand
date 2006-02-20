class AddressController < ApplicationController
  include LoginSystem
  layout "employers"
  before_filter :set_title
  before_filter :login_required
  before_filter :prepare_student
  before_filter :prepare_user

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
  
  # this method saves the contacts to dbase
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
    redirect_to :controller => 'study_plans'
  end
  
  # sets title of the controller
  def set_title
    @title = _('Contacts')
  end
end
