class FinalExamApproval < Approval
  
  belongs_to :index, :foreign_key => 'document_id'

  def document
    index
  end
end
