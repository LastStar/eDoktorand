class AddConsultantPermissionToSecretary < ActiveRecord::Migration
  def self.up
    Permission.create('name' => 'students/edit_consultant')
    Permission.create('name' => 'students/save_consultant')
    Role.find(2).permissions << Permission.find_by_name('students/edit_consultant')
    Role.find(2).permissions << Permission.find_by_name('students/save_consultant')
  end

  def self.down
    Permission.find_by_name('students/edit_consultant').destroy
    Permission.find_by_name('students/save_consultant').destroy

  end
end
