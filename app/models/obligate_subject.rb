class ObligateSubject < CoridorSubject
  validates_presence_of :coridor

  # returns requisite subject for coridor
  def self.for_coridor(coridor)
    coridor = coridor.id if coridor.is_a?(Coridor)
    self.find_all_by_coridor_id(coridor)
  end

end
