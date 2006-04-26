class AddPermissionsToStudent < ActiveRecord::Migration
  def self.up
    Role.find(3).permissions << Permission.create('name' => 'study_plans/final_application')
    Role.find(3).permissions << Permission.create('name' => 'study_plans/save_final_application')
  end

  def self.down
    p = Permission.find_by_name('study_plans/final_application')
    Role.find(3).permissions.delete(p)
    p.destroy
    p = Permission.find_by_name('study_plans/save_final_application')
    Role.find(3).permissions.delete(p)
    p.destroy
  end
end
