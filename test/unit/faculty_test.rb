require File.dirname(__FILE__) + '/../test_helper'

class FacultyTest < Test::Unit::TestCase
  fixtures :faculties

  def setup
    @faculty = Faculty.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Faculty,  @faculty
  end
end
