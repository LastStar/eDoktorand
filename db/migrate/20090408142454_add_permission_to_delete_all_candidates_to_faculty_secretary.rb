class AddPermissionToDeleteAllCandidatesToFacultySecretary < ActiveRecord::Migration
  def self.up
    Role.find(2).permissions <<
      Permission.create('name' => 'candidates/delete_all_candidates')
    Role.find(2).permissions <<
      Permission.create('name' => 'candidates/destroy_all_candidates')

  end
  def self.down
    permission = Permission.find_by_name('candidates/delete_all_candidates')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('candidates/destroy_all_candidates')
    Role.find(2).permissions.delete(permission)
    permission.destroy
  end
end
