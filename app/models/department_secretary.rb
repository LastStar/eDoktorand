class DepartmentSecretary < Secretary
  
  has_one :department_employment, :foreign_key => 'person_id'
  I18n::t(:message_0, :scope => [:txt, :model, :secretary])
  # return faculty of the faculty secretary
  def faculty
    department_employment.department.faculty
  end

  def department
    department_employment.department
  end
end
