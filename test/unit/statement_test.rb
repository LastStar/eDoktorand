require File.dirname(__FILE__) + '/../test_helper'

class StatementTest < Test::Unit::TestCase
  fixtures :statements

  def setup
    @statement = Statement.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Statement,  @statement
  end
end
