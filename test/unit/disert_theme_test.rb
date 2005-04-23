require File.dirname(__FILE__) + '/../test_helper'

class DisertThemeTest < Test::Unit::TestCase
  fixtures :disert_themes

  def setup
    @disert_theme = DisertTheme.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of DisertTheme,  @disert_theme
  end
end
