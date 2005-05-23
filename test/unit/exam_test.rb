require File.dirname(__FILE__) + '/../test_helper'

class ExamTest < Test::Unit::TestCase
  fixtures :exams

  def setup
    @exam = Exam.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Exam,  @exam
  end
end
