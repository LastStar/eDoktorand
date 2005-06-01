require File.dirname(__FILE__) + '/../test_helper'

class PlanApprovementTest < Test::Unit::TestCase
  fixtures :plan_approvements

  def setup
    @plan_approvement = PlanApprovement.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of PlanApprovement,  @plan_approvement
  end
end
