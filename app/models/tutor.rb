class Tutor < Examinator
  untranslate_all
  has_one :tutorship, :foreign_key => 'tutor_id'
  has_many :indices
  Nt(:message_0, :scope => [:txt, :model, :tutor])
  Nt(:message_1, :scope => [:txt, :model, :tutor])
  Nt(:message_2, :scope => [:txt, :model, :tutor])

  def self.find_for_coridors(coridors)
    find(:all, :conditions => ["tutorships.coridor_id in (?)", coridors],
         :include => [:tutorship, :title_before, :title_after],
         :order => 'lastname')
  end

  def self.find_for_faculty(faculty)
    find_for_coridors(faculty.coridors)
  end

  # returns coridor from tutorship
  # TODO redo with delegation
  def coridor
    tutorship.coridor
  end
end
