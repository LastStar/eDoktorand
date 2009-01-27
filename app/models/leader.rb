class Leader < Tutor
  untranslate_all
  has_one :leadership
  Nt(:message_0, :scope => [:txt, :model, :leader])
  Nt(:message_1, :scope => [:txt, :model, :leader])
  Nt(:message_2, :scope => [:txt, :model, :leader])
  Nt(:message_3, :scope => [:txt, :model, :leader])
  
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
    if leadership
      index.department == department
    end
  end
end
