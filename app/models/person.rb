class Person < ActiveRecord::Base
  validates_presence_of :lastname
  validates_presence_of :firstname
  # returns display name for person
  def display_name
    arr = [self.title_before.name, self.firstname, self.lastname]
    arr <<  self.title_after.name if self.title_after
    return arr.join(' ')
  end

end
