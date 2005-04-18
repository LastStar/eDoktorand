class StudyPlan < ActiveRecord::Base
  belongs_to :index
  belongs_to :status, :class_name => 'StudyPlanStatus'
  
  validates_associated :index
end
