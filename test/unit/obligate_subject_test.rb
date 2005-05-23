require File.dirname(__FILE__) + '/../test_helper'

class ObligateSubjectTest < Test::Unit::TestCase
  fixtures :obligate_subjects

  def setup
    @obligate_subject = ObligateSubject.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of ObligateSubject,  @obligate_subject
  end
end
