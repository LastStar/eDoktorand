class Person < ActiveRecord::Base
  validates_presence_of :lastname
  validates_presence_of :firstname
end
