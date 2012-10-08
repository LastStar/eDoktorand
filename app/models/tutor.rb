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
  #TODO redo with delegation
  def specialization
    tutorship.specialization
  end

  # returns external chairman
  #FIXME this is crazy shit man
  def self.external_chairman
    return Tutor.find_by_firstname_and_lastname("externi", "predseda")
  end

  # TODO document and spec
  def email
    if read_attribute(:email)
      return read_attribute(:email)
    elsif user
      return "#{user}@#{faculty.ldap_context}.czu.cz"
    end
    ""
  end
end
