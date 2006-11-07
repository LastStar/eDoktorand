class DepartmentEmployment < Employment
  untranslate_all
  belongs_to :department, :foreign_key => 'unit_id'
  belongs_to :person
end
