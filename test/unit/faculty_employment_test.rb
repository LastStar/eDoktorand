require File.dirname(__FILE__) + '/../test_helper'

class FacultyEmploymentTest < Test::Unit::TestCase
  fixtures :faculty_employments

  def setup
    @faculty_employment = FacultyEmployment.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of FacultyEmployment,  @faculty_employment
  end
end
