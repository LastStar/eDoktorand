class AddMorePermissionsToVicerector < ActiveRecord::Migration
  def self.up
    Role.find(8).permissions <<
    Permission.find_by_name('disert_themes/upload_methodology')
    Role.find(8).permissions <<
    Permission.find_by_name('students/mail_list')
    Role.find(8).permissions <<
    Permission.find_by_name('candidates/list_admission_ready')
  end

  def self.down
    permission = Permission.find_by_name('disert_themes/upload_methodology')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('students/mail_list')
    Role.find(8).permissions.delete(permission)
    permission = Permission.find_by_name('candidates/list_admission_ready')
    Role.find(8).permissions.delete(permission)
  end
end
