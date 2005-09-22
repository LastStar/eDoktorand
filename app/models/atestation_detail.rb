class AtestationDetail < ActiveRecord::Base
  belongs_to :study_plan
  validates_associated :study_plan
end
