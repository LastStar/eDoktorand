require File.dirname(__FILE__) + '/../test_helper'

class AdmitanceTest < Test::Unit::TestCase
  fixtures :admitances

  def setup
    @admitance = Admitance.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Admitance,  @admitance
  end
end
