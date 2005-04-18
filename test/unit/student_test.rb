require File.dirname(__FILE__) + '/../test_helper'

class StudentTest < Test::Unit::TestCase
  fixtures :students

  def setup
    @student = Student.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Student,  @student
  end
end
