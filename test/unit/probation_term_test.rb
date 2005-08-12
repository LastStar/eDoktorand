require File.dirname(__FILE__) + '/../test_helper'

class ProbationTermTest < Test::Unit::TestCase
  fixtures :probation_terms

  def setup
    @probation_term = ProbationTerm.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of ProbationTerm,  @probation_term
  end
end
