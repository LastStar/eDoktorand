class ChangeEditPersonalPermissionsToStudents < ActiveRecord::Migration
  def self.up
    Role.find(3).permissions.delete
      Permission.find_by_name('scholarships/save_email').destroy
    Role.find(3).permissions.delete
      Permission.find_by_name('scholarships/edit_email').destroy
    Role.find(3).permissions.delete
      Permission.find_by_name('scholarships/save_phone').destroy
    Role.find(3).permissions.delete
      Permission.find_by_name('scholarships/edit_phone').destroy
    Role.find(3).permissions.delete
      Permission.find_by_name('scholarships/save_citizenship').destroy
    Role.find(3).permissions.delete
      Permission.find_by_name('scholarships/edit_citizenship').destroy
    Role.find(3).permissions << Permission.create('name' => 
                                                  'students/save_email')
    Role.find(3).permissions << Permission.create('name' =>
                                                  'students/edit_email')
    Role.find(3).permissions << Permission.create('name' =>
                                                  'students/save_phone')
    Role.find(3).permissions << Permission.create('name' =>
                                                  'students/edit_phone')
    Role.find(3).permissions << Permission.create('name' =>
                                                  'students/save_citizenship')
    Role.find(3).permissions << Permission.create('name' =>
                                                  'students/edit_citizenship')
  end

  def self.down
    Role.find(3).permissions.delete
      Permission.find_by_name('students/save_email').destroy
    Role.find(3).permissions.delete
      Permission.find_by_name('students/edit_email').destroy
    Role.find(3).permissions.delete
      Permission.find_by_name('students/save_phone').destroy
    Role.find(3).permissions.delete
      Permission.find_by_name('students/edit_phone').destroy
    Role.find(3).permissions.delete
      Permission.find_by_name('students/save_citizenship').destroy
    Role.find(3).permissions.delete
      Permission.find_by_name('students/edit_citizenship').destroy
  end
end
