class Address < ActiveRecord::Base
  belongs_to :student
  belongs_to :type, :class_name => 'AddressType'
  validates_presence_of :street
  validates_presence_of :desc_number
  validates_presence_of :city
  validates_presence_of :zip
end
