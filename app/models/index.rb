class Index < ActiveRecord::Base
  belongs_to :student 
  belongs_to :tutorship
  has_one :study_plan
  has_one :disert_theme
  has_one :corridor
  has_one :department
  validates_presence_of :student
  validates_presence_of :tutorship
end
