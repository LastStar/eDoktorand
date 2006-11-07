class DepartmentSecretary < Secretary
  untranslate_all
  has_one :department_employment, :foreign_key => 'person_id'
  # return faculty of the faculty secretary
  def faculty
    department_employment.department.faculty
  end

  def department
    department_employment.department
  end
end
