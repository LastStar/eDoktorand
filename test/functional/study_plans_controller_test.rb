require File.dirname(__FILE__) + '/../test_helper'
require 'study_plans_controller'

# Re-raise errors caught by the controller.
class StudyPlansController; def rescue_action(e) raise e end; end

class StudyPlansControllerTest < Test::Unit::TestCase
  def setup
    @controller = StudyPlansController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
