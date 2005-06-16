class FacultySecretary < Secretary
  has_one :faculty_employment, :foreign_key => 'person_id'
end
