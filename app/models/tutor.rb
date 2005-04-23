class Tutor < Person
  has_one :tutorship
  validates_presence_of :tutorship
end
