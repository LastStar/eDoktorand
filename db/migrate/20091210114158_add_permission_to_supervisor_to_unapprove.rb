class AddPermissionToSupervisorToUnapprove < ActiveRecord::Migration
  def self.up
    Role.find_by_name('supervisor').permissions << Permission.create('name' => 'scholarships/unapprove')
  end

  def self.down
    permission = Permission.find_by_name('scholarships/unapprove')
    Role.find_by_name('supervisor').permissions.delete(permission)
    permission.destroy
  end
end
