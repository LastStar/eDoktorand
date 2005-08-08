class VoluntarySubject < CoridorSubject 
  validates_presence_of :coridor
  belongs_to :coridor
  belongs_to :subject
end
