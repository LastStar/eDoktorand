class Examinator < Person
  has_one :department_employment, :foreign_key => 'person_id'
  def self.for_html_select(user)
    if user.has_role?('faculty_secretary')
      find_for_faculty(user.person.faculty.id)
    elsif user.has_one_of_roles?(['department_secretary', 'tutor', 'leader'])
      find_for_department(user.person.department.id)
    end.map {|e| [e.display_name, e.id]}
  end

  def self.find_for_department(department)
    department = department.id if department.is_a? Department
    find(:all, :conditions => ["employments.unit_id = ?",
      department], :include => :department_employment)
  end
  def self.find_for_faculty(faculty)
    faculty = faculty.id if faculty.is_a? Faculty
    dep_ids = ActiveRecord::Base.connection.select_values(
      "select id from departments where faculty_id = #{faculty}")
    find(:all, :conditions => ["employments.unit_id IN (?)",
       dep_ids], :include => :department_employment)
  end
end