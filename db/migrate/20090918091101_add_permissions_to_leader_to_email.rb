class AddPermissionsToLeaderToEmail < ActiveRecord::Migration
  def self.up
    Role.find(6).permissions <<
    Permission.find_by_name('students/mail_list')
  end

  def self.down
    permission = Permission.find_by_name('students/mail_list')
    Role.find(6).permissions.delete(permission)
  end
end
