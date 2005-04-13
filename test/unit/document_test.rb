require File.dirname(__FILE__) + '/../test_helper'

class DocumentTest < Test::Unit::TestCase
  fixtures :documents

  def setup
    @document = Document.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Document,  @document
  end
end
