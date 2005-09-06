require 'leader'
class Tutor < Person
  has_one :tutorship
  has_many :indexes
  validates_presence_of :tutorship
  # return faculty of tutor
  def faculty
    tutorship.department.faculty
  end
end
