require 'genderize'

class Person < ActiveRecord::Base
  include Genderize
  untranslate_all
  N_('Person')
  has_one :email, :class_name => 'Contact', :foreign_key => 'person_id',
      :conditions => 'contact_type_id = 1'
  has_one :phone, :class_name => 'Contact', :foreign_key => 'person_id',
      :conditions => 'contact_type_id = 2'
  belongs_to :title_before, :class_name => 'Title', :foreign_key => 
    'title_before_id'
  belongs_to :title_after, :class_name => 'Title', :foreign_key =>
    'title_after_id'
  has_one :user, :dependent => :destroy

  validates_presence_of :lastname
  validates_presence_of :firstname

  # returns display name for person
  def display_name
    arr = self.title_before ? [self.title_before.label] : []
    arr << [ self.firstname, self.lastname + (self.title_after ? ',' : '')]
    arr << self.title_after.label if self.title_after
    return arr.join(' ')
  end

  def is_leader_of?(index)
    return false
  end

  def is_dean_of?(index)
    return false
  end

  def email=(value)
    email_or_new.update_attribute(:name, value)
  end

  def phone=(value)
    phone_or_new.update_attribute(:name, value)
  end
 
  def email_or_new
    return email if email
    Contact.new_email_for(id)
  end

  def phone_or_new
    return phone if phone
    Contact.new_phone_for(id)
  end

  def email_name
    unless email
      ""
    else
      email.name
    end
  end

  def <=>(other)
    lastname <=> other.lastname
  end

  def self.find_for(user)
    if user.has_role? 'vicerector'
      find(:all, :order => 'lastname')
    elsif user.has_one_of_roles? ['faculty_secretary', 'dean']
      find_for_faculty(user.person.faculty)
    elsif user.has_one_of_roles? ['tutor', 'department_secretary']
      find_for_department(user.person.department)
    end
  end

end
