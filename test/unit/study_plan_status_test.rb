require File.dirname(__FILE__) + '/../test_helper'

class StudyPlanStatusTest < Test::Unit::TestCase
  fixtures :study_plan_status

  def setup
    @study_plan_status = StudyPlanStatus.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of StudyPlanStatus,  @study_plan_status
  end
end
