class Index < ActiveRecord::Base
  belongs_to :student 
  belongs_to :tutorship
  belongs_to :department
  belongs_to :study_plan
  belongs_to :disert_theme
  belongs_to :coridor
end
