class Tutor < Examinator
  untranslate_all
  has_one :tutorship, :foreign_key => 'tutor_id'
  has_many :indices
  N_("Tutor")
  N_("approve like tutor")
  N_('atest like tutor')

  def self.find_for_coridors(coridors)
    find(:all, :conditions => ["tutorships.coridor_id in (?)",
      coridors], :include => :tutorship, :order => 'lastname')
  end

  def self.find_for_faculty(faculty)
    find_for_coridors(faculty.coridors)
  end

  def self.find_for(user)
    if user.has_role? 'vicerector'
      find(:all, :order => 'lastname')
    elsif user.has_one_of_roles? ['faculty_secretary', 'dean']
      find_for_faculty(user.person.faculty)
    elsif user.has_one_of_roles? ['tutor', 'department_secretary']
      find_for_department(user.person.department)
    end
  end

  # returns coridor from tutorship
  # TODO redo with delegation
  def coridor
    tutorship.coridor
  end
end
