 class StudyInterruptApproval < Approval
  
  belongs_to :interrupt, :foreign_key => 'document_id', :class_name => 'StudyInterrupt'
  # returns index of interrupt
  def index
    interrupt.index
  end

  # returns interrupt
  def document
    interrupt
  end
end
