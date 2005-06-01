require File.dirname(__FILE__) + '/../test_helper'

class DeanTest < Test::Unit::TestCase
  fixtures :deans

  def setup
    @dean = Dean.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Dean,  @dean
  end
end
