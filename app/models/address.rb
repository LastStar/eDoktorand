class Address < ActiveRecord::Base

  belongs_to :student
  belongs_to :address_type
  validates_presence_of :student

  # return address formated in one line
  def to_line_s
    return [[self.street, self.desc_number].join(' '), self.city, self.zip].join(', ')
  end

  class << self 
    def create_habitat_for(student)
      student = student.id if student.is_a? Student
      create(:student_id => student, :address_type_id => 1)
    end

    def new_habitat_for(student)
      student = student.id if student.is_a? Student
      new(:student_id => student, :address_type_id => 1)
    end
  end
end
