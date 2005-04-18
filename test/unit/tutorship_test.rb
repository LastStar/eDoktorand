require File.dirname(__FILE__) + '/../test_helper'

class TutorshipTest < Test::Unit::TestCase
  fixtures :tutorships

  def setup
    @tutorship = Tutorship.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Tutorship,  @tutorship
  end
end
