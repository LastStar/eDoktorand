require File.dirname(__FILE__) + '/../test_helper'
require 'candidates_controller'

# Re-raise errors caught by the controller.
class CandidatesController; def rescue_action(e) raise e end; end

class CandidatesControllerTest < Test::Unit::TestCase
  fixtures :candidates

  def setup
    @controller = CandidatesController.new
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
    assert_template_has 'candidates'
  end

  def test_show
    process :show, 'id' => 1
    assert_rendered_file 'show'
    assert_template_has 'candidate'
    assert_valid_record 'candidate'
  end

  def test_new
    process :new
    assert_rendered_file 'new'
    assert_template_has 'candidate'
  end

  def test_create
    num_candidates = Candidate.find_all.size

    process :create, 'candidate' => { }
    assert_redirected_to :action => 'list'

    assert_equal num_candidates + 1, Candidate.find_all.size
  end

  def test_edit
    process :edit, 'id' => 1
    assert_rendered_file 'edit'
    assert_template_has 'candidate'
    assert_valid_record 'candidate'
  end

  def test_update
    process :update, 'candidate' => { 'id' => 1 }
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil Candidate.find(1)

    process :destroy, 'id' => 1
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      candidate = Candidate.find(1)
    }
  end
end
