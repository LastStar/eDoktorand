class AddPermissionsToFacultySecretary < ActiveRecord::Migration
  def self.up
    
    Role.find(2).permissions <<
      Permission.create('name' => 'students/edit_display_name')
    Role.find(2).permissions <<
      Permission.create('name' => 'students/save_display_name')
  end

  def self.down
    Role.find(2).permissions.delete
      Permission.find_by_name('students/edit_display_name')
    Role.find(2).permissions.delete
      Permission.find_by_name('students/save_display_name')
  end
end
