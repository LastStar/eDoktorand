require File.dirname(__FILE__) + '/../test_helper'
require 'faculties_controller'

# Re-raise errors caught by the controller.
class FacultiesController; def rescue_action(e) raise e end; end

class FacultiesControllerTest < Test::Unit::TestCase
  fixtures :faculties

  def setup
    @controller = FacultiesController.new
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
    assert_template_has 'faculties'
  end

  def test_show
    process :show, 'id' => 1
    assert_rendered_file 'show'
    assert_template_has 'faculty'
    assert_valid_record 'faculty'
  end

  def test_new
    process :new
    assert_rendered_file 'new'
    assert_template_has 'faculty'
  end

  def test_create
    num_faculties = Faculty.find_all.size

    process :create, 'faculty' => { }
    assert_redirected_to :action => 'list'

    assert_equal num_faculties + 1, Faculty.find_all.size
  end

  def test_edit
    process :edit, 'id' => 1
    assert_rendered_file 'edit'
    assert_template_has 'faculty'
    assert_valid_record 'faculty'
  end

  def test_update
    process :update, 'faculty' => { 'id' => 1 }
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil Faculty.find(1)

    process :destroy, 'id' => 1
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      faculty = Faculty.find(1)
    }
  end
end
