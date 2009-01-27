class Leader < Tutor
  
  has_one :leadership
  I18n::t(:message_0, :scope => [:txt, :model, :leader])
  I18n::t(:message_1, :scope => [:txt, :model, :leader])
  I18n::t(:message_2, :scope => [:txt, :model, :leader])
  I18n::t(:message_3, :scope => [:txt, :model, :leader])
  
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
