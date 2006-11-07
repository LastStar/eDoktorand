class Address < ActiveRecord::Base
untranslate_all
  belongs_to :student, :order =>
  'created_on desc'
  belongs_to :type, :class_name => 'AddressType'
  validates_presence_of :student
  # return address formated in one line
  def to_line_s
    return [[self.street, self.desc_number].join(' '), self.city, self.zip].join(', ')
  end

  def self.create_habitat_for(student)
    student = student.id if student.is_a? Student
    create(:student_id => student, :address_type_id => 1)
  end

  def self.new_habitat_for(student)
    student = student.id if student.is_a? Student
    new(:student_id => student, :address_type_id => 1)
  end
end
