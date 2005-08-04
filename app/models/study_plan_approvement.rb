class StudyPlanApprovement < Approvement
  belongs_to :study_plan, :foreign_key => 'document_id'
end
