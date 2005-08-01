require File.dirname(__FILE__) + '/../test_helper'

class AtestationTermTest < Test::Unit::TestCase
  fixtures :atestation_terms

  def setup
    @atestation_term = AtestationTerm.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of AtestationTerm,  @atestation_term
  end
end
