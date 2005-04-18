class Tutor < Person
  has_one :tutorship
  has_many :contacts, :foreign_key => 'person_id'
  validates_presence_of :contacts, :on => :update
  validates_associated :contacts, :on => :update
end
