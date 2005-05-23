class Deanship < ActiveRecord::Base
  belongs_to :dean
  belongs_to :faculty
  has_many :indexes
  validates_presence_of :dean
  validates_presence_of :faculty
end
