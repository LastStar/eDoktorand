class Leader < Tutor
  
  has_one :leadership
  
  # return faculty of the leader
  def faculty
    department.faculty
  end

  def department
    if leadership
      leadership.department
    else
      super
    end
  end

  def is_leader_of?(index)
    if leadership
      index.department == department
    end
  end
end
