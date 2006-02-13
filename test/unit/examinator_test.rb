require File.dirname(__FILE__) + '/../test_helper'

class ExaminatorTest < Test::Unit::TestCase
  fixtures :examinators

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Examinator, examinators(:first)
  end
end
