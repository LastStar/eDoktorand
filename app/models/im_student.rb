# Every student should have one ImStudent created by migration.
# On every update of student its ImStudent should be updated also.
# On every create of student ImStudent should be created.
# Once a night Eventlog would be created for every updated/created ImStudent
class ImStudent < ActiveRecord::Base
  belongs_to :student

  validates_presence_of :student

  before_save :get_student_attributes

  # gets attributtes from student relation
  def get_student_attributes
    self.uic = student.uic
    self.lastname = student.lastname
    self.firstname = student.firstname
    self.birthname = student.birthname
    self.birth_number = student.birth_number
    self.sex = student.sex
    self.created_on = student.created_on
    self.title_before = student.title_before.label if student.title_before
    self.title_after = student.title_after.label if student.title_after
    self.birth_place = student.birth_place
    self.birth_on = student.birth_on
    self.email = student.email
    self.phone = student.phone
    self.citizenship = student.citizenship
  end
end
