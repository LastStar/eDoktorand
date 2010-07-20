class IMStudent < ActiveRecord::Base
  belongs_to :student

  validates_presence_of :student

  before_save :get_student_attributes

  private
  # gets attributtes from student relation
  def get_student_attributes
    self.uic = student.uic
    self.lastname = student.lastname
    self.firstname = student.firstname
    self.birthname = student.birthname
    self.birth_number = student.birth_number
    self.sex = student.sex
    self.created_on = student.created_on
    self.title_before = student.title_before.label
    self.title_after = student.title_after.label
    self.birth_place = student.birth_place
    self.birth_on = student.birth_on
    self.email = student.email
    self.phone = student.phone
    self.citizenship = student.citizenship
  end
end
