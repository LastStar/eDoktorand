require File.dirname(__FILE__) + '/../test_helper'

class LanguageSubjectTest < Test::Unit::TestCase
  fixtures :language_subjects

  def setup
    @language_subject = LanguageSubject.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of LanguageSubject,  @language_subject
  end
end
