require File.dirname(__FILE__) + '/../test_helper'

class TitleTest < Test::Unit::TestCase
  fixtures :titles

  def setup
    @title = Title.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Title,  @title
  end
end
