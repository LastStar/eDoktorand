require File.dirname(__FILE__) + '/../test_helper'

class EmploymentTest < Test::Unit::TestCase
  fixtures :employments

  def setup
    @employment = Employment.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Employment,  @employment
  end
end
