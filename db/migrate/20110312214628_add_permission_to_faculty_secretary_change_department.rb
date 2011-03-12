class AddPermissionToFacultySecretaryChangeDepartment < ActiveRecord::Migration
  def self.up
	Permission.create(:name => "students/edit_department")
    Permission.create(:name => "students/save_department")
    Role.find(2).permissions << Permission.find_by_name("students/edit_department")
    Role.find(2).permissions << Permission.find_by_name("students/save_department")
  end

  def self.down
	Role.find(2).permissions.delete(Permission.find_by_name("students/edit_department"))
    Role.find(2).permissions.delete(Permission.find_by_name("students/save_department"))
    Permission.find_by_name("students/edit_department").destroy
    Permission.find_by_name("students/save_department").destroy
  end
end
