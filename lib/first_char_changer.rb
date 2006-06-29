class String
  def first_up
    self.slice(0, 1).upcase.concat(self.slice(1..-1))
  end

  def first_down
    self.slice(0, 1).downcase.concat(self.slice(1..-1))
  end
end
