class AddPermissionToEditFinalAreas < ActiveRecord::Migration
  def self.up
       Role.find(2).permissions <<
      Permission.create('name' => 'study_plans/add_cz')
       Role.find(2).permissions <<
      Permission.create('name' => 'study_plans/save_cz')
  end

  def self.down
    permission = Permission.find_by_name('study_plans/add_cz')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('study_plans/save_cz')
    Role.find(2).permissions.delete(permission)
    permission.destroy

  end
end
