class Address < ActiveRecord::Base
  belongs_to :student, :order =>
  'created_on desc'
  belongs_to :type, :class_name => 'AddressType'
  validates_presence_of :student
  # return address formated in one line
  def to_line_s
    return [[self.street, self.desc_number].join(' '), self.city, self.zip].join(', ')
  end
end
