require File.dirname(__FILE__) + '/../test_helper'

class InteruptTest < Test::Unit::TestCase
  fixtures :interupts

  def setup
    @interupt = Interupt.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Interupt,  @interupt
  end
end
