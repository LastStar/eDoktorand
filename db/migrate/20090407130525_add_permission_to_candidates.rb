class AddPermissionToCandidates < ActiveRecord::Migration
  def self.up
    Role.find(2).permissions <<
      Permission.create('name' => 'candidates/set_foreign_payer')
  end

  def self.down
    permission = Permission.find_by_name('candidates/set_foreign_payer')
    Role.find(2).permissions.delete(permission)
    permission.destroy
  end
end
