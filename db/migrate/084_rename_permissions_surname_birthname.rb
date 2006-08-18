class RenamePermissionsSurnameBirthname < ActiveRecord::Migration
  def self.up
    Permission.find_by_name('students/edit_surname').destroy
    Permission.find_by_name('students/save_surname').destroy
    Permission.create('name' => 'students/edit_birthname')
    Permission.create('name' => 'students/save_birthname')
    Role.find(2).permissions << Permission.find_by_name('students/edit_birthname')
    Role.find(2).permissions << Permission.find_by_name('students/save_birthname')
    Role.find(3).permissions << Permission.find_by_name('students/edit_birthname')
    Role.find(3).permissions << Permission.find_by_name('students/save_birthname')
  end

  def self.down
    Permission.find_by_name('students/edit_birthname').destroy
    Permission.find_by_name('students/save_birthname').destroy
    Permission.create('name' => 'students/edit_surname')
    Permission.create('name' => 'students/save_surname')
    Role.find(2).permissions << Permission.find_by_name('students/edit_surname')
    Role.find(2).permissions << Permission.find_by_name('students/save_surname')
    Role.find(3).permissions << Permission.find_by_name('students/edit_surname')
    Role.find(3).permissions << Permission.find_by_name('students/save_surname')
  end
end
