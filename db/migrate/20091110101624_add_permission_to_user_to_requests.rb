class AddPermissionToUserToRequests < ActiveRecord::Migration
  def self.up
    Role.find_by_name('student').permissions << Permission.create('name' => 'study_plans/requests')
  end

  def self.down
    permission = Permission.find_by_name('study_plans/requests')
    Role.find('student').permissions.delete(permission)
    permission.destroy
  end
end
