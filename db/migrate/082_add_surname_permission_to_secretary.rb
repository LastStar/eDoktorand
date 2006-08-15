class AddSurnamePermissionToSecretary < ActiveRecord::Migration
  def self.up
    Permission.create('name' => 'students/edit_surname')
    Permission.create('name' => 'students/save_surname')
    Role.find(2).permissions << Permission.find_by_name('students/edit_surname')
    Role.find(2).permissions << Permission.find_by_name('students/save_surname')
    Role.find(3).permissions << Permission.find_by_name('students/edit_surname')
    Role.find(3).permissions << Permission.find_by_name('students/save_surname')

  end

  def self.down
    Permission.find_by_name('students/edit_surname').destroy
    Permission.find_by_name('students/save_surname').destroy
  end
end
