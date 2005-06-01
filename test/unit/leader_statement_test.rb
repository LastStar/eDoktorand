require File.dirname(__FILE__) + '/../test_helper'

class LeaderStatementTest < Test::Unit::TestCase
  fixtures :leader_statements

  def setup
    @leader_statement = LeaderStatement.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of LeaderStatement,  @leader_statement
  end
end
