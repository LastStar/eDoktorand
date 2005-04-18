require File.dirname(__FILE__) + '/../test_helper'

class IndexTest < Test::Unit::TestCase
  fixtures :indexes

  def setup
    @index = Index.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Index,  @index
  end
end
