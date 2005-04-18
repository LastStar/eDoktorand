class Student < Person
  has_one :index
  has_one :address, :conditions => 'address_type_id = 1'
  has_one :postal_address, :class_name => 'Address', :conditions => 'address_type_id = 2'
  has_one :email, :class_name => 'Contact', :foreign_key => 'person_id', :conditions => 'contact_type_id = 1'
  has_one :phone, :class_name => 'Contact', :foreign_key => 'person_id', :conditions => 'contact_type_id = 2'
  has_one :candidate
  belongs_to :title_before, :class_name => 'Title', :foreign_key => 'title_before_id'
  belongs_to :title_after, :class_name => 'Title', :foreign_key => 'title_after_id'
  validates_presence_of :address, :on => :update
  validates_associated :address, :on => :update
  validates_presence_of :email, :on => :update
  validates_associated :email, :on => :update
  # returns display name for student
  def display_name
    arr = [self.title_before.name, self.firstname, self.lastname]
    arr <<  self.title_after.name if self.title_after
    return arr.join(' ')
  end
end 
