class FacultySecretary < Secretary
  
  has_one :faculty_employment, :foreign_key => 'person_id'

  # return faculty of the leader
  def faculty
    faculty_employment.faculty
  end
end
