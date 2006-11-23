class AddEditTutor < ActiveRecord::Migration
  def self.up
    Role.find(2).permissions <<
      Permission.create('name' => 'students/edit_tutor')
    Role.find(2).permissions <<
      Permission.create('name' => 'students/save_tutor')
  end

  def self.down
   Role.find(2).permissions.delete
      Permission.find_by_name('students/edit_tutor')
    Role.find(2).permissions.delete
      Permission.find_by_name('students/save_tutors')
  end
end
