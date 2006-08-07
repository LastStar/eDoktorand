require File.dirname(__FILE__) + '/../test_helper'
require 'exam_terms_controller'

# Re-raise errors caught by the controller.
class ExamTermsController; def rescue_action(e) raise e end; end

class ExamTermsControllerTest < Test::Unit::TestCase
  fixtures :exam_terms,:users

  def setup
    @controller = ExamTermsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_redirected_to 'login'
    assert_rendered_file 'list'
  end

  def test_list
    get :list
    assert_rendered_file 'list'
    assert_template_has 'exam_terms'
  end

  def test_show
    get :show, 'id' => 1
    assert_rendered_file 'show'
    assert_template_has 'exam_term'
    assert_valid_record 'exam_term'
  end

  def test_new
    get :new
    assert_rendered_file 'new'
    assert_template_has 'exam_term'
  end

  def test_create
    num_exam_terms = ExamTerm.find_all.size

    post :create, 'exam_term' => { }
    assert_redirected_to :action => 'list'

    assert_equal num_exam_terms + 1, ExamTerm.find_all.size
  end

  def test_edit
    get :edit, 'id' => 1
    assert_rendered_file 'edit'
    assert_template_has 'exam_term'
    assert_valid_record 'exam_term'
  end

  def test_update
    post :update, 'id' => 1
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil ExamTerm.find(1)

    post :destroy, 'id' => 1
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      exam_term = ExamTerm.find(1)
    }
  end
end
