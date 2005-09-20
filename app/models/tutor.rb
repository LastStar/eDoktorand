class Tutor < Person
  has_one :tutorship
  has_many :indexes
  # return faculty of tutor
  def faculty
  # blood hack
    if tutorship
      tutorship.department.faculty
    end
  end
end
