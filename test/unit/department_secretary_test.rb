require File.dirname(__FILE__) + '/../test_helper'

class DepartmentSecretaryTest < Test::Unit::TestCase
  fixtures :department_secretaries

  def setup
    @department_secretary = DepartmentSecretary.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of DepartmentSecretary,  @department_secretary
  end
end
