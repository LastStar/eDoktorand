class Leader < Tutor
  untranslate_all
  has_one :leadership
  N_('Leader')
  N_('final exam')
  N_('approve like leader')
  N_('atest like leader')
  
  # return faculty of the leader
  def faculty
    leadership.department.faculty
  end

  def department
    if leadership
      leadership.department
    else
      super
    end
  end

  def is_leader_of?(index)
    index.department == department
  end
end
