require File.dirname(__FILE__) + '/../test_helper'

class SubjectTest < Test::Unit::TestCase
  fixtures :subjects

  def setup
    @subject = Subject.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Subject,  @subject
  end
end
