require File.dirname(__FILE__) + '/../test_helper'

class ApprovementTest < Test::Unit::TestCase
  fixtures :approvements

  def setup
    @approvement = Approvement.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Approvement,  @approvement
  end
end
