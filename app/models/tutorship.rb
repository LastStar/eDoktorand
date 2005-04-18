class Tutorship < ActiveRecord::Base
  belongs_to :tutor
  belongs_to :department
  belongs_to :coridor
  has_many :indexes
  validates_presence_of :tutor
  validates_presence_of :department
  validates_presence_of :coridor
end
