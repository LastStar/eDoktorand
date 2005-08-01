require File.dirname(__FILE__) + '/../test_helper'
require 'atestation_terms_controller'

# Re-raise errors caught by the controller.
class AtestationTermsController; def rescue_action(e) raise e end; end

class AtestationTermsControllerTest < Test::Unit::TestCase
  fixtures :atestation_terms

  def setup
    @controller = AtestationTermsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
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

    assert_not_nil assigns(:atestation_terms)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:atestation_terms)
    assert assigns(:atestation_terms).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:atestation_terms)
  end

  def test_create
    num_atestation_terms = AtestationTerms.count

    post :create, :atestation_terms => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_atestation_terms + 1, AtestationTerms.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:atestation_terms)
    assert assigns(:atestation_terms).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil AtestationTerms.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      AtestationTerms.find(1)
    }
  end
end
