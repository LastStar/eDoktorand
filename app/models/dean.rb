class Dean < Leader
  untranslate_all
  has_one :deanship

  Nt(:message_0, :scope => [:txt, :model, :dean])
  Nt(:message_1, :scope => [:txt, :model, :dean])
  Nt(:message_2, :scope => [:txt, :model, :dean])
 
  # return faculty of the dean
  def faculty
    deanship.faculty
  end

  def is_dean_of?(index)
    self.deanship.faculty == index.faculty
  end
end
