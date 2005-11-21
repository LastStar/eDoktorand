module ScholarshipsHelper
require 'scholarship_calculator'
  def print_scholarship(index)
    ScholarshipCalculator.scholarship_for(index.student)
  end
end
