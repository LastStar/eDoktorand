class Tutor < Examinator
  
  has_one :tutorship, :foreign_key => 'tutor_id'
  has_many :indices

  def self.find_for_specializations(specializations)
    find(:all, :conditions => ["tutorships.specialization_id in (?)", specializations],
         :include => [:tutorship, :title_before, :title_after],
         :order => 'lastname')
  end

  def self.find_for_faculty(faculty)
    find_for_specializations(faculty.specializations)
  end

  # returns specialization from tutorship
  # TODO redo with delegation
  def specialization
    tutorship.specialization
  end

 # returns external chairman
  def self.external_chairman
    return Tutor.find_by_firstname_and_lastname("externi","predseda")
  end

end
