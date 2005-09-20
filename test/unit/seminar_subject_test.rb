require File.dirname(__FILE__) + '/../test_helper'

class SeminarSubjectTest < Test::Unit::TestCase
  fixtures :seminar_subjects

  def setup
    @seminar_subject = SeminarSubject.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of SeminarSubject,  @seminar_subject
  end
end
