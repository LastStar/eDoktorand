require File.dirname(__FILE__) + '/../test_helper'

class ExternalSubjectDetailTest < Test::Unit::TestCase
  fixtures :external_subject_details

  def setup
    @external_subject_detail = ExternalSubjectDetail.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of ExternalSubjectDetail,  @external_subject_detail
  end
end
