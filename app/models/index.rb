class Index < ActiveRecord::Base
  belongs_to :student 
  belongs_to :tutor
  belongs_to :study
  has_one :study_plan, :conditions => 'admited_on IS NOT NULL and canceled_on
  IS NULL'
  has_one :disert_theme
  belongs_to :coridor
  belongs_to :department
  validates_presence_of :student
  validates_presence_of :tutor
end
