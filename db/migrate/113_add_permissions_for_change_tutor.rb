class AddPermissionsForChangeTutor < ActiveRecord::Migration
  def self.up
    Permission.create(:name => "students/change_tutor")
    Permission.create(:name => "students/change_tutor_confirm")
    Role.find_by_name("student").permissions << Permission.find_by_name('students/change_tutor')
    Role.find_by_name("student").permissions << Permission.find_by_name('students/change_tutor_confirm')
  end

  def self.down
    Permission.find_by_name("students/change_tutor").destroy
    Permission.find_by_name("students/change_tutor_confirm").destroy
  end
end
