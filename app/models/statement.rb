class Statement < ActiveRecord::Base
  has_many :approvements
  validates_presence_of :approvements
end
