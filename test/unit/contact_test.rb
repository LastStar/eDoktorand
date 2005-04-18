require File.dirname(__FILE__) + '/../test_helper'

class ContactTest < Test::Unit::TestCase
  fixtures :contacts

  def setup
    @contact = Contact.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Contact,  @contact
  end
end
