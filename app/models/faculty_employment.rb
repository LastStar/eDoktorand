class FacultyEmployment < Employment
  
  belongs_to :faculty, :foreign_key => 'unit_id'
  belongs_to :person
end
