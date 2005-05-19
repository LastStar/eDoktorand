require File.dirname(__FILE__) + '/../test_helper'

class ExamTermTest < Test::Unit::TestCase
  fixtures :exam_terms

  def setup
    @exam_term = ExamTerm.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of ExamTerm,  @exam_term
  end
end
