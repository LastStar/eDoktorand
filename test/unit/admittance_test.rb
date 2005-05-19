require File.dirname(__FILE__) + '/../test_helper'

class AdmittanceTest < Test::Unit::TestCase
  fixtures :admittances

  def setup
    @admittance = Admittance.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Admittance,  @admittance
  end
end
