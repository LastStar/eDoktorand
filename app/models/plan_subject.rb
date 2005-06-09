class PlanSubject < ActiveRecord::Base
  belongs_to :study_plan
  belongs_to :subject
end
