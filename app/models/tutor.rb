class Tutor < Examinator
  
  has_one :tutorship, :foreign_key => 'tutor_id'
  has_many :indices

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
