class Dean < Leader
  
  has_one :deanship

  # return faculty of the dean
  def faculty
    deanship.faculty
  end

  def dean_of?(index)
    self.deanship.faculty == index.faculty
  end
end
