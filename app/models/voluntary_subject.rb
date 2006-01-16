class VoluntarySubject < CoridorSubject 
  validates_presence_of :coridor
  belongs_to :coridor
  belongs_to :subject
  # returns requisite subject for coridor
  def self.for_coridor(coridor)
    coridor = coridor.id if coridor.is_a?(Coridor)
    self.find_all_by_coridor_id(coridor)
  end
  # returns requisite as select options subject for coridor
  def self.for_select(coridor)
    coridor = coridor.id if coridor.is_a?(Coridor)
    self.find_all_by_coridor_id(coridor).map {|sub| [sub.subject.label, sub.subject.id]}
  end
end
