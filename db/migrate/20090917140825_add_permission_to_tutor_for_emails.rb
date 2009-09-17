class AddPermissionToTutorForEmails < ActiveRecord::Migration
  def self.up
    Role.find(4).permissions <<
    Permission.find_by_name('students/mail_list')
    Role.find(4).permissions <<
    Permission.find_by_name('students/admin_edit_mail')
    Role.find(4).permissions <<
    Permission.find_by_name('students/admin_update_mail') end

  def self.down
    permission = Permission.find_by_name('students/mail_list')
    Role.find(4).permissions.delete(permission)
    permission = Permission.find_by_name('students/admin_edit_mail')
    Role.find(4).permissions.delete(permission)
    permission = Permission.find_by_name('students/admin_update_mail')
    Role.find(4).permissions.delete(permission)
  end
end
