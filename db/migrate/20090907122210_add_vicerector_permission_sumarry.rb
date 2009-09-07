class AddVicerectorPermissionSumarry < ActiveRecord::Migration
  def self.up
    Role.find(8).permissions <<
    Permission.find_by_name('candidates/summary')
  end

  def self.down
    permission = Permission.find_by_name('candidates/summary')
    Role.find(8).permissions.delete(permission)
  end
end
