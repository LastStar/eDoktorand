require File.dirname(__FILE__) + '/../test_helper'
require 'interupts_controller'

# Re-raise errors caught by the controller.
class InteruptsController; def rescue_action(e) raise e end; end

class InteruptsControllerTest < Test::Unit::TestCase
  def setup
    @controller = InteruptsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
