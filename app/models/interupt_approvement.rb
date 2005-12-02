class InteruptApprovement < Approvement
  belongs_to :interupt, :foreign_key => 'document_id'
  # returns index of interupt
  def index
    interupt.index
  end
end
