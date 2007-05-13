require File.dirname(__FILE__) + '/../test_helper'
require 'diploma_supplements_controller'

# Re-raise errors caught by the controller.
class DiplomaSupplementsController; def rescue_action(e) raise e end; end

class DiplomaSupplementsControllerTest < Test::Unit::TestCase
  fixtures :diploma_supplements

  def setup
    @controller = DiplomaSupplementsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = diploma_supplements(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:diploma_supplements)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:diploma_supplement)
    assert assigns(:diploma_supplement).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:diploma_supplement)
  end

  def test_create
    num_diploma_supplements = DiplomaSupplement.count

    post :create, :diploma_supplement => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_diploma_supplements + 1, DiplomaSupplement.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:diploma_supplement)
    assert assigns(:diploma_supplement).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      DiplomaSupplement.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      DiplomaSupplement.find(@first_id)
    }
  end
end
