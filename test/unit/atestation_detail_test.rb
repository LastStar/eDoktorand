require File.dirname(__FILE__) + '/../test_helper'

class AtestationDetailTest < Test::Unit::TestCase
  fixtures :atestation_details

  def setup
    @atestation_detail = AtestationDetail.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of AtestationDetail,  @atestation_detail
  end
end
