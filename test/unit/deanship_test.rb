require File.dirname(__FILE__) + '/../test_helper'

class DeanshipTest < Test::Unit::TestCase
  fixtures :deanships

  def setup
    @deanship = Deanship.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Deanship,  @deanship
  end
end
