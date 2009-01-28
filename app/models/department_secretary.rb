class DepartmentSecretary < Secretary
  
  has_one :department_employment, :foreign_key => 'person_id'

  # return faculty 
  def faculty
    department.faculty
  end

  # returns department 
  def department
    department_employment.department
  end
end
