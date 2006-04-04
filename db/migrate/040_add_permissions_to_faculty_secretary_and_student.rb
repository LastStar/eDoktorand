class AddPermissionsToFacultySecretaryAndStudent < ActiveRecord::Migration
  def self.up
    Permission.create('name' => 'scholarships/save')
    Permission.create('name' => 'scholarships/add')
    Permission.create('name' => 'scholarships/destroy')
    Permission.create('name' => 'scholarships/edit')
    Permission.create('name' => 'scholarships/pay')
    Role.find(2).permissions << Permission.find_by_name('scholarships/save')
    Role.find(2).permissions << Permission.find_by_name('scholarships/destroy')
    Role.find(2).permissions << Permission.find_by_name('scholarships/add')
    Role.find(2).permissions << Permission.find_by_name('scholarships/edit')
    Role.find(2).permissions << Permission.find_by_name('scholarships/pay')
    Role.find(2).permissions << Permission.find_by_name('study_plans/atest')
    Permission.create('name' => 'study_plans/final_application')
    Role.find(3).permissions << Permission.find_by_name('study_plans/final_application')
  end

  def self.down
    Role.find(2).permissions.delete(Permission.find_by_name('study_plans/atest'))
    Role.find(2).permissions.delete(Permission.find_by_name('scholarships/save'))
    Role.find(2).permissions.delete(Permission.find_by_name('scholarships/edit'))
    Role.find(2).permissions.delete(Permission.find_by_name('scholarships/pay'))
    Role.find(2).permissions.delete(
      Permission.find_by_name('scholarships/destroy'))
    Role.find(2).permissions.delete(Permission.find_by_name('scholarships/edit'))
    Role.find(3).permissions.delete(Permission.find_by_name('study_plans/final_application'))
    Permission.find_by_name('study_plans/final_application').destroy
    Permission.find_by_name('scholarships/save').destroy
    Permission.find_by_name('scholarships/add').destroy
    Permission.find_by_name('scholarships/edit').destroy
    Permission.find_by_name('scholarships/pay').destroy
  end
end
