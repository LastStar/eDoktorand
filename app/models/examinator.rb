class Examinator < Person
  untranslate_all
  has_one :department_employment, :foreign_key => 'person_id'

  def self.find_for_department(department)
    find(:all, :conditions => ["employments.unit_id = ?", department],
         :include => [:department_employment, :title_before, :title_after],
         :order => 'lastname')
  end

  def self.find_for_faculty(faculty)
    faculty = faculty.id if faculty.is_a? Faculty
    dep_ids = ActiveRecord::Base.connection.select_values(
      "select id from departments where faculty_id = #{faculty}")
    find(:all, :conditions => ["employments.unit_id IN (?)",
    dep_ids], :include => [:department_employment, :title_before, :title_after], :order => 'lastname')
  end

  # returns department
  def department
    department_employment.department
  end

  # returns faculty of examinator
  def faculty
    department.faculty
  end

end
