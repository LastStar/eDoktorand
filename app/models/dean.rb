class Dean < Leader
  has_one :deanship
  # return faculty of the dean
  def faculty
    deanship.faculty
  end

end
