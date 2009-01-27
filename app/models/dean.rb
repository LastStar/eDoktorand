class Dean < Leader
  
  has_one :deanship

  I18n::t(:message_0, :scope => [:txt, :model, :dean])
  I18n::t(:message_1, :scope => [:txt, :model, :dean])
  I18n::t(:message_2, :scope => [:txt, :model, :dean])
 
  # return faculty of the dean
  def faculty
    deanship.faculty
  end

  def is_dean_of?(index)
    self.deanship.faculty == index.faculty
  end
end
