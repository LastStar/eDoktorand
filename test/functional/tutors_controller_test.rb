require File.dirname(__FILE__) + '/../test_helper'
require 'tutors_controller'

# Re-raise errors caught by the controller.
class TutorsController; def rescue_action(e) raise e end; end

class TutorsControllerTest < Test::Unit::TestCase
  def setup
    @controller = TutorsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
