class AddStudentChangePermissions < ActiveRecord::Migration
  def self.up
    Role.find(1).permissions << Permission.create('name' => 'study_plans/change')
    Role.find(1).permissions << Permission.create('name' => 'study_plans/save_full')
  end

  def self.down
    permission = Permission.find_by_name('study_plans/switch_study')
    Role.find(1).permissions.delete(permission)
    permission = Permission.find_by_name('study_plans/save_full')
    Role.find(1).permissions.delete(permission)
  end
end
