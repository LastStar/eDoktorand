class Tutorship < ActiveRecord::Base
  
  belongs_to :tutor
  belongs_to :specialization
  validates_presence_of :tutor
  validates_presence_of :specialization
end
