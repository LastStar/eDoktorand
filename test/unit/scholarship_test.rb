require File.dirname(__FILE__) + '/../test_helper'

class ScholarshipTest < Test::Unit::TestCase
  fixtures :scholarships

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Scholarship, scholarships(:first)
  end
end
