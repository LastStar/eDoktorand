require File.dirname(__FILE__) + '/../test_helper'

class LanguageTest < Test::Unit::TestCase
  fixtures :languages

  def setup
    @language = Language.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Language,  @language
  end
end
