class Dean < Leader
  has_one :deanship
  # return faculty of the dean
  def faculty
    deanship.faculty
  end

  def is_dean_of?(student)
    self.deanship.faculty == student.faculty
  end
end
