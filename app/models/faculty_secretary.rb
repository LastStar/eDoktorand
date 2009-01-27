class FacultySecretary < Secretary
  
  has_one :faculty_employment, :foreign_key => 'person_id'
  # return faculty of the leader
  I18n::t(:message_0, :scope => [:txt, :model, :secretary])
  def faculty
    faculty_employment.faculty
  end
end
