class StudyPlanApprovement < Approvement
  belongs_to :study_plan, :foreign_key => 'document_id'
  acts_as_audited
  # returns index
  def index
    study_plan.index
  end

  # returns study plan
  def document
    study_plan
  end
end
