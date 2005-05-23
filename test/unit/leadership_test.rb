require File.dirname(__FILE__) + '/../test_helper'

class LeadershipTest < Test::Unit::TestCase
  fixtures :leaderships

  def setup
    @leadership = Leadership.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Leadership,  @leadership
  end
end
