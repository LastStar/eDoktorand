require File.dirname(__FILE__) + '/../test_helper'
require 'languages_controller'

# Re-raise errors caught by the controller.
class LanguagesController; def rescue_action(e) raise e end; end

class LanguagesControllerTest < Test::Unit::TestCase
  fixtures :languages

  def setup
    @controller = LanguagesController.new
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
    assert_template_has 'languages'
  end

  def test_show
    process :show, 'id' => 1
    assert_rendered_file 'show'
    assert_template_has 'language'
    assert_valid_record 'language'
  end

  def test_new
    process :new
    assert_rendered_file 'new'
    assert_template_has 'language'
  end

  def test_create
    num_languages = Language.find_all.size

    process :create, 'language' => { }
    assert_redirected_to :action => 'list'

    assert_equal num_languages + 1, Language.find_all.size
  end

  def test_edit
    process :edit, 'id' => 1
    assert_rendered_file 'edit'
    assert_template_has 'language'
    assert_valid_record 'language'
  end

  def test_update
    process :update, 'language' => { 'id' => 1 }
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil Language.find(1)

    process :destroy, 'id' => 1
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      language = Language.find(1)
    }
  end
end
