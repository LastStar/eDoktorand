require File.dirname(__FILE__) + '/../test_helper'

class StudyTest < Test::Unit::TestCase
  fixtures :studies

  def setup
    @study = Study.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Study,  @study
  end
end
