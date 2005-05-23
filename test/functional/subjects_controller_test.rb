require File.dirname(__FILE__) + '/../test_helper'
require 'subjects_controller'

# Re-raise errors caught by the controller.
class SubjectsController; def rescue_action(e) raise e end; end

class SubjectsControllerTest < Test::Unit::TestCase
  fixtures :subjects

  def setup
    @controller = SubjectsController.new
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
    assert_template_has 'subjects'
  end

  def test_show
    get :show, 'id' => 1
    assert_rendered_file 'show'
    assert_template_has 'subject'
    assert_valid_record 'subject'
  end

  def test_new
    get :new
    assert_rendered_file 'new'
    assert_template_has 'subject'
  end

  def test_create
    num_subjects = Subject.find_all.size

    post :create, 'subject' => { }
    assert_redirected_to :action => 'list'

    assert_equal num_subjects + 1, Subject.find_all.size
  end

  def test_edit
    get :edit, 'id' => 1
    assert_rendered_file 'edit'
    assert_template_has 'subject'
    assert_valid_record 'subject'
  end

  def test_update
    post :update, 'id' => 1
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil Subject.find(1)

    post :destroy, 'id' => 1
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      subject = Subject.find(1)
    }
  end
end
