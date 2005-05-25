require File.dirname(__FILE__) + '/../test_helper'

class ExternalSubjectTest < Test::Unit::TestCase
  fixtures :external_subjects

  def setup
    @external_subject = ExternalSubject.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of ExternalSubject,  @external_subject
  end
end
