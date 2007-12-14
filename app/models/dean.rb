class Dean < Leader
  untranslate_all
  has_one :deanship

  N_("Dean")
  N_("approve like dean")
  N_('atest like dean')
 
  # return faculty of the dean
  def faculty
    deanship.faculty
  end

  def is_dean_of?(index)
    self.deanship.faculty == index.faculty
  end
end
