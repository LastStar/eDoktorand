require File.dirname(__FILE__) + '/../test_helper'
require 'studies_controller'

# Re-raise errors caught by the controller.
class StudiesController; def rescue_action(e) raise e end; end

class StudiesControllerTest < Test::Unit::TestCase
  fixtures :studies

  def setup
    @controller = StudiesController.new
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
    assert_template_has 'studies'
  end

  def test_show
    process :show, 'id' => 1
    assert_rendered_file 'show'
    assert_template_has 'study'
    assert_valid_record 'study'
  end

  def test_new
    process :new
    assert_rendered_file 'new'
    assert_template_has 'study'
  end

  def test_create
    num_studies = Study.find_all.size

    process :create, 'study' => { }
    assert_redirected_to :action => 'list'

    assert_equal num_studies + 1, Study.find_all.size
  end

  def test_edit
    process :edit, 'id' => 1
    assert_rendered_file 'edit'
    assert_template_has 'study'
    assert_valid_record 'study'
  end

  def test_update
    process :update, 'study' => { 'id' => 1 }
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil Study.find(1)

    process :destroy, 'id' => 1
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      study = Study.find(1)
    }
  end
end
