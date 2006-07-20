class AddPersonalEditPermissionsToSecretary < ActiveRecord::Migration
  def self.up
    Role.find(2).permissions <<
      Permission.find_by_name('students/edit_citizenship')
    Role.find(2).permissions <<
      Permission.find_by_name('students/save_citizenship')
    Role.find(2).permissions <<
      Permission.find_by_name('students/edit_account')
    Role.find(2).permissions <<
      Permission.find_by_name('students/save_account')
    Role.find(2).permissions <<
      Permission.find_by_name('students/edit_phone')
    Role.find(2).permissions <<
      Permission.find_by_name('students/save_phone')
    Role.find(2).permissions <<
      Permission.find_by_name('students/edit_email')
    Role.find(2).permissions <<
      Permission.find_by_name('students/save_email')
  end

  def self.down
    Role.find(2).permissions.delete
      Permission.find_by_name('students/edit_citizenship')
    Role.find(2).permissions.delete
      Permission.find_by_name('students/save_citizenship')
    Role.find(2).permissions.delete
      Permission.find_by_name('students/edit_account')
    Role.find(2).permissions.delete
      Permission.find_by_name('students/save_account')
    Role.find(2).permissions.delete
      Permission.find_by_name('students/edit_phone')
    Role.find(2).permissions.delete
      Permission.find_by_name('students/save_phone')
    Role.find(2).permissions.delete
      Permission.find_by_name('students/edit_email')
    Role.find(2).permissions.delete
      Permission.find_by_name('students/save_email')
  end
end
