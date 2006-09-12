class Leader < Tutor
  has_one :leadership
  # return faculty of the leader
  def faculty
    leadership.department.faculty
  end

  def department
    leadership.department
  end
end
