class Index < ActiveRecord::Base
  belongs_to :student 
  belongs_to :tutorship
  has_one :study_plan
  has_one :disert_theme
  validates_presence_of :student
  validates_presence_of :tutorship
end
