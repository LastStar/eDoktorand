require File.dirname(__FILE__) + '/../test_helper'

class CoridorsSubjectsTest < Test::Unit::TestCase
  fixtures :coridors_subjects

  def setup
    @coridors_subjects = CoridorsSubjects.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of CoridorsSubjects,  @coridors_subjects
  end
end
