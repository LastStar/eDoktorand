class Leadership < ActiveRecord::Base
  belongs_to :leader
  belongs_to :department
  validates_presence_of :leader
  validates_presence_of :department
end
