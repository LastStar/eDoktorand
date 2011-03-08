class AddPermissionToFacultySecretaryChangeSpecialization < ActiveRecord::Migration
  def self.up
    Permission.create(:name => "indices/edit_specialization")
    Permission.create(:name => "indices/save_specialization")
    Role.find(2).permissions << Permission.find_by_name("indices/edit_specialization")
    Role.find(2).permissions << Permission.find_by_name("indices/save_specialization")
    Permission.create(:name => "students/edit_specialization")
    Permission.create(:name => "students/save_specialization")
    Role.find(2).permissions << Permission.find_by_name("students/edit_specialization")
    Role.find(2).permissions << Permission.find_by_name("students/save_specialization")
  end

  def self.down
    Role.find(2).permissions.delete(Permission.find_by_name("indices/edit_specialization"))
    Role.find(2).permissions.delete(Permission.find_by_name("indices/save_specialization"))
    Permission.find_by_name("indices/edit_specialization").destroy
    Permission.find_by_name("indices/save_specialization").destroy
    Role.find(2).permissions.delete(Permission.find_by_name("students/edit_specialization"))
    Role.find(2).permissions.delete(Permission.find_by_name("students/save_specialization"))
    Permission.find_by_name("students/edit_specialization").destroy
    Permission.find_by_name("students/save_specialization").destroy
  end
end
