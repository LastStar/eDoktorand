require File.dirname(__FILE__) + '/../test_helper'

class PlanSubjectTest < Test::Unit::TestCase
  fixtures :plan_subjects

  def setup
    @plan_subject = PlanSubject.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of PlanSubject,  @plan_subject
  end
end
