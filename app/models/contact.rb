class Contact < ActiveRecord::Base
  untranslate_all
  validates_presence_of :name
  validates_presence_of :type
  belongs_to :type, :class_name => 'ContactType'
  belongs_to :person

  def self.new_email_for(person)
    person = person.id if person.is_a? Person
    new(:person_id => person, :contact_type_id => 1)
  end

  def self.new_phone_for(person)
    person = person.id if person.is_a? Person
    new(:person_id => person, :contact_type_id => 2)
  end
end
