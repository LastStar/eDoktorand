class AddPermissionToAdminMail < ActiveRecord::Migration
  def self.up
        Role.find(2).permissions <<
      Permission.create('name' => 'students/mail_list')
        Role.find(2).permissions <<
      Permission.create('name' => 'students/admin_edit_mail')
        Role.find(2).permissions <<
      Permission.create('name' => 'students/admin_update_mail')
  end

  def self.down
    permission = Permission.find_by_name('students/mail_list')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('students/admin_edit_mail')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('students/admin_update_mail')
    Role.find(2).permissions.delete(permission)
    permission.destroy
  end
end
