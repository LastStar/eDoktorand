require File.dirname(__FILE__) + '/../test_helper'

class DepartmentTest < Test::Unit::TestCase
  fixtures :departments

  def setup
    @department = Department.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Department,  @department
  end
end
