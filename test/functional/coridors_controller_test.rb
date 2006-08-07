require File.dirname(__FILE__) + '/../test_helper'
require 'coridors_controller'

# Re-raise errors caught by the controller.
class CoridorsController; def rescue_action(e) raise e end; end

class CoridorsControllerTest < Test::Unit::TestCase
  fixtures :coridors

  def setup
    @controller = CoridorsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    process :index
    assert_rendered_file 'list'
  end

  def test_list
    process :list
    assert_rendered_file 'list'
    assert_template_has 'coridors'
  end

  def test_show
    process :show, 'id' => 129
    assert_rendered_file 'show'
    assert_template_has 'coridor'
    assert_valid_record 'coridor'
  end

  def test_new
    process :new
    assert_rendered_file 'new'
    assert_template_has 'coridor'
  end

  def test_create
    num_coridors = Coridor.find_all.size

    process :create, 'coridor' => { }
    assert_redirected_to 'list'

    assert_equal num_coridors + 1, Coridor.find_all.size
  end

  def test_edit
    process :edit, 'id' => 129
    assert_rendered_file 'edit'
    assert_template_has 'coridor'
    assert_valid_record 'coridor'
  end

  def test_update
    process :update, 'coridor' => { 'id' => 129 }
    assert_redirected_to :action => 'show', :id => 129
  end

  def test_destroy
    assert_not_nil Coridor.find(129)

    process :destroy, 'id' => 129
    assert_redirected_to 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      coridor = Coridor.find(129)
    }
  end
end
