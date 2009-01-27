class DepartmentEmployment < Employment
  
  belongs_to :department, :foreign_key => 'unit_id'
  belongs_to :person
end
