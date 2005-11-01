require File.dirname(__FILE__) + '/../test_helper'

class ScholarshipTest < Test::Unit::TestCase
  fixtures :scholarships

  def setup
    @scholarship = Scholarship.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Scholarship,  @scholarship
  end
end
