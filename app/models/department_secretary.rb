class DepartmentSecretary < Secretary
  has_one :department_employment
  # return faculty of the faculty secretary
  def faculty
    department_employment.department.faculty
  end
end
