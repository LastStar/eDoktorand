require File.dirname(__FILE__) + '/../test_helper'

class AtestationTest < Test::Unit::TestCase
  fixtures :atestations

  def setup
    @atestation = Atestation.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Atestation,  @atestation
  end
end
