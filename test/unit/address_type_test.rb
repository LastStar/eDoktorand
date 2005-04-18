require File.dirname(__FILE__) + '/../test_helper'

class AddressTypeTest < Test::Unit::TestCase
  fixtures :address_types

  def setup
    @address_type = AddressType.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of AddressType,  @address_type
  end
end
