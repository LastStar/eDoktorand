class AtestationDetail < ActiveRecord::Base
  belongs_to :atestation_term
  belongs_to :study_plan
  validates_associated :atestation_term, :study_plan
end
