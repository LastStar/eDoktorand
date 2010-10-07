class AttestationDetail < ActiveRecord::Base
  
  belongs_to :study_plan
  validates_associated :study_plan
  
  def self.new_for(student)
    return new(:study_plan_id => student.study_plan.id,
               :attestation_term => Attestation.next_for_faculty(student.faculty))

  end
end
