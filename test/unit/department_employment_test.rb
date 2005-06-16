require File.dirname(__FILE__) + '/../test_helper'

class DepartmentEmploymentTest < Test::Unit::TestCase
  fixtures :department_employments

  def setup
    @department_employment = DepartmentEmployment.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of DepartmentEmployment,  @department_employment
  end
end
