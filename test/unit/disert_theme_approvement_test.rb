require File.dirname(__FILE__) + '/../test_helper'

class DisertThemeApprovementTest < Test::Unit::TestCase
  fixtures :disert_theme_approvements

  def setup
    @disert_theme_approvement = DisertThemeApprovement.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of DisertThemeApprovement,  @disert_theme_approvement
  end
end
