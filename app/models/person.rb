require 'genderize'

class Person < ActiveRecord::Base
  include Genderize
  has_one :email, :class_name => 'Contact', :foreign_key => 'person_id',
      :conditions => 'contact_type_id = 1'
  has_one :phone, :class_name => 'Contact', :foreign_key => 'person_id',
      :conditions => 'contact_type_id = 2'
  belongs_to :title_before, :class_name => 'Title', :foreign_key => 
    'title_before_id'
  belongs_to :title_after, :class_name => 'Title', :foreign_key =>
    'title_after_id'
  has_one :user

  validates_presence_of :lastname
  validates_presence_of :firstname

  # returns display name for person
  def display_name
    arr = self.title_before ? [self.title_before.label] : []
    arr << [ self.firstname, self.lastname + (self.title_after ? ',' : '')]
    arr << self.title_after.label if self.title_after
    return arr.join(' ')
  end

  def is_dean_of?(student)
    return false
  end

  def self.for_html_select(user)
    if user.has_role?('faculty_secretary')
      find_for_faculty(user.person.faculty.id)
    elsif user.has_one_of_roles?(['department_secretary', 'tutor', 'leader'])
      find_for_department(user.person.department.id)
    end.map {|e| [e.display_name, e.id]}
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
end
