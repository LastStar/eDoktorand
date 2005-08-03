require File.dirname(__FILE__) + '/../test_helper'

class StudyPlanApprovementTest < Test::Unit::TestCase
  fixtures :study_plan_approvements

  def setup
    @study_plan_approvement = StudyPlanApprovement.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of StudyPlanApprovement,  @study_plan_approvement
  end
end
