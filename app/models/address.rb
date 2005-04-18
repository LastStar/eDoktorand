class Address < ActiveRecord::Base
  belongs_to :student
  belongs_to :type, :class_name => 'AddressType'
  validates_presence_of :street
  validates_presence_of :desc_number
  validates_presence_of :city
  validates_presence_of :zip
  # return address formated in one line
  def to_line_s
    return [[self.street, self.desc_number].join(' '), self.city, self.zip].join(', ')
  end
end
