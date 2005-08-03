class Student < Person
  has_one :index, :foreign_key => 'student_id'
  has_one :address, :conditions => 'address_type_id = 1'
  has_one :postal_address, :class_name => 'Address', :conditions => 'address_type_id = 2'
  has_one :email, :class_name => 'Contact', :foreign_key => 'person_id', :conditions => 'contact_type_id = 1'
  has_one :phone, :class_name => 'Contact', :foreign_key => 'person_id', :conditions => 'contact_type_id = 2'
  has_one :candidate
  validates_presence_of :address, :on => :update
  validates_associated :address, :on => :update
  validates_presence_of :email, :on => :update
  validates_associated :email, :on => :update
  # returns faculty on which student is
  def faculty
    index.department.faculty
  end
end 
