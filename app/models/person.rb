require 'genderize'

class Person < ActiveRecord::Base
  include Genderize
  
  belongs_to :title_before, :class_name => 'Title', :foreign_key => 
    'title_before_id'
  belongs_to :title_after, :class_name => 'Title', :foreign_key =>
    'title_after_id'
  has_one :user, :dependent => :destroy

  validates_presence_of :lastname
  validates_presence_of :firstname

  # displays person type localized
  def display_type
    I18n::t(:user, :scope => [:txt, :model, self.class.to_s.underscore])
  end

  # returns display name for person
  def display_name
    display_name_with_title
  end

  def display_name_with_title
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

  def <=>(other)
    self.lastname <=> other.lastname
  end

  def self.find_for(user)
    if user.has_role? 'vicerector'
      find(:all, :order => 'lastname', :include => [:title_before, :title_after])
    elsif user.has_one_of_roles? ['faculty_secretary', 'dean']
      find_for_faculty(user.person.faculty)
    elsif user.has_one_of_roles? ['examinator', 'tutor', 'department_secretary']
      find_for_department(user.person.department)
    end
  end

  def staff_email
    if self.user
      "%s@%s.czu.cz" % [self.user.login, self.faculty.ldap_context]
    end
  end
end
