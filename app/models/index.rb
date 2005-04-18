class Index < ActiveRecord::Base
  belongs_to :student 
  has_many :study_plans
  belongs_to :tutorship
  validates_presence_of :student
  validates_presence_of :tutorship
end
