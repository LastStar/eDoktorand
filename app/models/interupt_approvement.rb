class InteruptApprovement < Approvement
  
  belongs_to :interupt, :foreign_key => 'document_id'
  # returns index of interupt
  def index
    interupt.index
  end

  # returns interrupt
  def document
    interupt
  end

  # creates chance for faculty secretary to approve like dean
  def prepare_statement(user)
    if user.has_role?('faculty_secretary')
      return build_dean_statement('person_id' => user.person.faculty.dean.id)
    else
      super(user)
    end
  end

  # creates chance for faculty secretary to approve like dean
  def prepares_statement?(user)
    if !dean_statement && user.has_role?('faculty_secretary')
      return true
    else
      super(user)
    end
  end

end
