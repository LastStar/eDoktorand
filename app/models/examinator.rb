class Examinator < DepartmentSecretary
  untranslate_all
  N_("Examinator")

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

end
