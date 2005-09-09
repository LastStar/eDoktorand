class Person < ActiveRecord::Base
  validates_presence_of :lastname
  validates_presence_of :firstname
  belongs_to :title_before, :class_name => 'Title', :foreign_key => 'title_before_id'
  belongs_to :title_after, :class_name => 'Title', :foreign_key =>
  'title_after_id'
  has_one :user
  # returns display name for person
  def display_name
  	arr = self.title_before ? [self.title_before.label] : []
    arr << [ self.firstname, self.lastname + (self.title_after ? ',' : '')]
    arr << self.title_after.label if self.title_after
    return arr.join(' ')
  end


end
