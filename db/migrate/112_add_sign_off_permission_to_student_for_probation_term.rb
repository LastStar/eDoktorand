class AddSignOffPermissionToStudentForProbationTerm < ActiveRecord::Migration
  def self.up
    Role.find(3).permissions <<
      Permission.create(:name => 'probation_terms/sign_off_student')
  end

  def self.down
   Role.find(3).permissions.delete
      Permission.find_by_name('probation_terms/sign_off_student')
  end
end
