require File.dirname(__FILE__) + '/../test_helper'

class FacultySecretaryTest < Test::Unit::TestCase
  fixtures :faculty_secretaries

  def setup
    @faculty_secretary = FacultySecretary.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of FacultySecretary,  @faculty_secretary
  end
end
