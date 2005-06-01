require File.dirname(__FILE__) + '/../test_helper'

class DeanStatementTest < Test::Unit::TestCase
  fixtures :dean_statements

  def setup
    @dean_statement = DeanStatement.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of DeanStatement,  @dean_statement
  end
end
