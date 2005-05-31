class StudyPlan < ActiveRecord::Base
  belongs_to :index
  has_many :plan_subjects
  validates_presence_of :index
end
