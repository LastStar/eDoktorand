class Deanship < ActiveRecord::Base
  
  belongs_to :dean
  belongs_to :faculty
  validates_presence_of :dean
  validates_presence_of :faculty
end
