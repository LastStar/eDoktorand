class RequisiteSubject < CoridorSubject
  # returns true if has requisite subject
  def self.has_for_coridor?(coridor)
    coridor = coridor.id if coridor.is_a?(Coridor)
    self.count("coridor_id = #{coridor}") > 0
  end

  # returns requisite subject for coridor
  def self.for_coridor(coridor)
    coridor = coridor.id if coridor.is_a?(Coridor)
    self.find_all_by_coridor_id(coridor)
  end

end
