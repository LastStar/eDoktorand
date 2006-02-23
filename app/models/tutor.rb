class Tutor < Examinator
  has_one :tutorship, :foreign_key => 'tutor_id'
  has_many :indexes
  # return faculty of tutor
  def faculty
  # blood hack
    if tutorship
      tutorship.department.faculty
    end
  end
  def self.find_for_faculty(faculty)
    faculty = faculty.id if faculty.is_a? Faculty
    dep_ids = ActiveRecord::Base.connection.select_values(
      "select id from departments where faculty_id = #{faculty}")
    find(:all, :conditions => ["tutorships.department_id IN (?)",
       dep_ids], :include => :tutorship)
  end
end
