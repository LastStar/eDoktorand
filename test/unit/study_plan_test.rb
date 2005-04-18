require File.dirname(__FILE__) + '/../test_helper'

class StudyPlanTest < Test::Unit::TestCase
  fixtures :study_plans

  def setup
    @study_plan = StudyPlan.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of StudyPlan,  @study_plan
  end
end
