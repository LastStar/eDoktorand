require File.dirname(__FILE__) + '/../test_helper'

class MethodologyTest < Test::Unit::TestCase
  fixtures :methodologies

  def setup
    @methodology = Methodology.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Methodology,  @methodology
  end
end
