class Tutor < Person
  has_one :tutorship
  has_many :indexes
  validates_presence_of :tutorship
end
