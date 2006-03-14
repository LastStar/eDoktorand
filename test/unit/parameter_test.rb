require File.dirname(__FILE__) + '/../test_helper'

class ParameterTest < Test::Unit::TestCase
  fixtures :parameters

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Parameter, parameters(:first)
  end
end
