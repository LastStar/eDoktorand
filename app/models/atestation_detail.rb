class AtestationDetail < ActiveRecord::Base
  untranslate_all
  belongs_to :study_plan
  validates_associated :study_plan
  
  def self.new_for(student)
    new(:study_plan_id => student.study_plan.id,
       :atestation_term => Atestation.next_for_faculty(student.faculty)) 

  end
end
