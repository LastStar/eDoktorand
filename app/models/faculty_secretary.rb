class FacultySecretary < Secretary

  has_one :faculty_employment, :foreign_key => 'person_id'

  # return faculty of the faculty secretary
  def faculty
    faculty_employment.faculty
  end
end
