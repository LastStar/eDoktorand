class PlanSubject < ActiveRecord::Base
  belongs_to :study_plan
  has_one :subject
  validates_presence_of :study_plan
  validates_presence_of :subject
end
