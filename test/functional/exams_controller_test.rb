require File.dirname(__FILE__) + '/../test_helper'
require 'exams_controller'

# Re-raise errors caught by the controller.
class ExamsController; def rescue_action(e) raise e end; end

class ExamsControllerTest < Test::Unit::TestCase
  fixtures :exams

  def setup
    @controller = ExamsController.new
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
    assert_template_has 'exams'
  end

  def test_show
    get :show, 'id' => 1
    assert_rendered_file 'show'
    assert_template_has 'exam'
    assert_valid_record 'exam'
  end

  def test_new
    get :new
    assert_rendered_file 'new'
    assert_template_has 'exam'
  end

  def test_create
    num_exams = Exam.find_all.size

    post :create, 'exam' => { }
    assert_redirected_to :action => 'list'

    assert_equal num_exams + 1, Exam.find_all.size
  end

  def test_edit
    get :edit, 'id' => 1
    assert_rendered_file 'edit'
    assert_template_has 'exam'
    assert_valid_record 'exam'
  end

  def test_update
    post :update, 'id' => 1
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil Exam.find(1)

    post :destroy, 'id' => 1
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      exam = Exam.find(1)
    }
  end
end
