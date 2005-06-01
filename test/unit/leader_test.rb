require File.dirname(__FILE__) + '/../test_helper'

class LeaderTest < Test::Unit::TestCase
  fixtures :leaders

  def setup
    @leader = Leader.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Leader,  @leader
  end
end
