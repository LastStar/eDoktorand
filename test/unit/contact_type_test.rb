require File.dirname(__FILE__) + '/../test_helper'

class ContactTypeTest < Test::Unit::TestCase
  fixtures :contact_types

  def setup
    @contact_type = ContactType.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of ContactType,  @contact_type
  end
end
