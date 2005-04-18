require File.dirname(__FILE__) + '/../test_helper'
require 'contact_types_controller'

# Re-raise errors caught by the controller.
class ContactTypesController; def rescue_action(e) raise e end; end

class ContactTypesControllerTest < Test::Unit::TestCase
  fixtures :contact_types

  def setup
    @controller = ContactTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_rendered_file 'list'
  end

  def test_list
    get :list
    assert_rendered_file 'list'
    assert_template_has 'contact_types'
  end

  def test_show
    get :show, 'id' => 1
    assert_rendered_file 'show'
    assert_template_has 'contact_type'
    assert_valid_record 'contact_type'
  end

  def test_new
    get :new
    assert_rendered_file 'new'
    assert_template_has 'contact_type'
  end

  def test_create
    num_contact_types = ContactType.find_all.size

    post :create, 'contact_type' => { }
    assert_redirected_to :action => 'list'

    assert_equal num_contact_types + 1, ContactType.find_all.size
  end

  def test_edit
    get :edit, 'id' => 1
    assert_rendered_file 'edit'
    assert_template_has 'contact_type'
    assert_valid_record 'contact_type'
  end

  def test_update
    post :update, 'id' => 1
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil ContactType.find(1)

    post :destroy, 'id' => 1
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      contact_type = ContactType.find(1)
    }
  end
end
