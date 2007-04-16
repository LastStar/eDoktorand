class Tutor < Examinator
  untranslate_all
  has_one :tutorship, :foreign_key => 'tutor_id'
  has_many :indices
  N_("Tutor")
  N_("approve like tutor")
  N_('atest like tutor')

  # return faculty of tutor
  def faculty
  # TODO fix this with data validation
  # blood hack
    if tutorship
      tutorship.department.faculty
    end
  end
  
  def department
    tutorship.department
  end

  def self.find_for_department(department)
    department = department.id if department.is_a? Department
    find(:all, :conditions => ["tutorships.department_id = ?",
      department], :include => :tutorship, :order => 'lastname')
  end

  def self.find_for_faculty(faculty)
    faculty = faculty.id if faculty.is_a? Faculty
    dep_ids = ActiveRecord::Base.connection.select_values(
      "select id from departments where faculty_id = #{faculty}")
    find(:all, :conditions => ["tutorships.department_id IN (?)",
       dep_ids], :include => :tutorship, :order => 'lastname')
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
end
