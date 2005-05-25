class Index < ActiveRecord::Base
  belongs_to :student 
  belongs_to :tutor
  has_one :study_plan
  has_one :disert_theme
  belongs_to :coridor
  belongs_to :department
  validates_presence_of :student
  validates_presence_of :tutor
end
