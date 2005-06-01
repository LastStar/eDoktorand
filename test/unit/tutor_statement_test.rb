require File.dirname(__FILE__) + '/../test_helper'

class TutorStatementTest < Test::Unit::TestCase
  fixtures :tutor_statements

  def setup
    @tutor_statement = TutorStatement.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of TutorStatement,  @tutor_statement
  end
end
