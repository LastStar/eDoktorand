require File.dirname(__FILE__) + '/../test_helper'
require 'scholarships_controller'

# Re-raise errors caught by the controller.
class ScholarshipsController; def rescue_action(e) raise e end; end

class ScholarshipsControllerTest < Test::Unit::TestCase
  def setup
    @controller = ScholarshipsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
