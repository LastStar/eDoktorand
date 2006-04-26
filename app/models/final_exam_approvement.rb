class FinalExamApprovement < Approvement
  belongs_to :index, :foreign_key => 'document_id'
  acts_as_audited

  def document
    index
  end
end
