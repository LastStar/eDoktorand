require File.dirname(__FILE__) + '/../test_helper'

class ActualityTest < Test::Unit::TestCase
  fixtures :actualities

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Actuality, actualities(:first)
  end
end
