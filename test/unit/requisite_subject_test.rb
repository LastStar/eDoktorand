require File.dirname(__FILE__) + '/../test_helper'

class RequisiteSubjectTest < Test::Unit::TestCase
  fixtures :requisite_subjects

  def setup
    @requisite_subject = RequisiteSubject.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of RequisiteSubject,  @requisite_subject
  end
end
