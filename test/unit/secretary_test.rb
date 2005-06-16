require File.dirname(__FILE__) + '/../test_helper'

class SecretaryTest < Test::Unit::TestCase
  fixtures :secretaries

  def setup
    @secretary = Secretary.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Secretary,  @secretary
  end
end
