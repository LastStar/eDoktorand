require File.dirname(__FILE__) + '/../test_helper'

class InteruptApprovementTest < Test::Unit::TestCase
  fixtures :interupt_approvements

  # Replace this with your real tests.
  def test_truth
    assert_kind_of InteruptApprovement, interupt_approvements(:first)
  end
end
