require File.dirname(__FILE__) + '/../test_helper'
require 'acl_controller_controller'

# Re-raise errors caught by the controller.
class ACLControllerController; def rescue_action(e) raise e end; end

class ACLControllerControllerTest < Test::Unit::TestCase
  def setup
    @controller = ACLControllerController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
