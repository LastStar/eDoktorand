require File.dirname(__FILE__) + '/../test_helper'
require 'departments_controller'

# Re-raise errors caught by the controller.
class DepartmentsController; def rescue_action(e) raise e end; end

class DepartmentsControllerTest < Test::Unit::TestCase
  fixtures :departments

  def setup
    @controller = DepartmentsController.new
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
    assert_template_has 'departments'
  end

  def test_show
    process :show, 'id' => 1
    assert_rendered_file 'show'
    assert_template_has 'department'
    assert_valid_record 'department'
  end

  def test_new
    process :new
    assert_rendered_file 'new'
    assert_template_has 'department'
  end

  def test_create
    num_departments = Department.find_all.size

    process :create, 'department' => { }
    assert_redirected_to :action => 'list'

    assert_equal num_departments + 1, Department.find_all.size
  end

  def test_edit
    process :edit, 'id' => 1
    assert_rendered_file 'edit'
    assert_template_has 'department'
    assert_valid_record 'department'
  end

  def test_update
    process :update, 'department' => { 'id' => 1 }
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil Department.find(1)

    process :destroy, 'id' => 1
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      department = Department.find(1)
    }
  end
end
