require File.dirname(__FILE__) + '/../test_helper'

class CandidateTest < Test::Unit::TestCase
  fixtures :candidates

  def setup
    @candidate = Candidate.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Candidate,  @candidate
  end
end
