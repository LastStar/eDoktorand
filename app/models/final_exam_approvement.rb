class FinalExamApprovement < Approvement
  untranslate_all
  belongs_to :index, :foreign_key => 'document_id'
  acts_as_audited

  def document
    index
  end
end
