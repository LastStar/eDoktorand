class PlanApprovement < Approvement
  untranslate_all
  belongs_to :study_plan, :foreign_key => 'document_id'
end
