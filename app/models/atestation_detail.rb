class AtestationDetail < ActiveRecord::Base
  untranslate_all
  belongs_to :study_plan
  validates_associated :study_plan
end
