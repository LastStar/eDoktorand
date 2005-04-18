class Contact < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :type
  belongs_to :type, :class_name => 'ContactType'
end
