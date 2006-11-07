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
    leadership.department
  end
end
