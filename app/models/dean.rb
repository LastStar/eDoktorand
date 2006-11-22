class Dean < Leader
  untranslate_all
  has_one :deanship
  # return faculty of the dean
  N_("Dean")
  N_("approve like dean")
  N_('atest like dean')
  def faculty
    deanship.faculty
  end

  def is_dean_of?(student)
    self.deanship.faculty == student.faculty
  end
end
