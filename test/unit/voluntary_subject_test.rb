require File.dirname(__FILE__) + '/../test_helper'

class VoluntarySubjectTest < Test::Unit::TestCase
  fixtures :voluntary_subjects

  def setup
    @voluntary_subject = VoluntarySubject.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of VoluntarySubject,  @voluntary_subject
  end
end
