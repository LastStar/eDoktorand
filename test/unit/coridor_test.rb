require File.dirname(__FILE__) + '/../test_helper'

class CoridorTest < Test::Unit::TestCase
  fixtures :coridors

  def setup
    @coridor = Coridor.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Coridor,  @coridor
  end
end
