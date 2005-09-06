class StudyPlanApprovement < Approvement
  belongs_to :study_plan, :foreign_key => 'document_id'
  # returns index
  def index
    self.study_plan.index
  end
end
