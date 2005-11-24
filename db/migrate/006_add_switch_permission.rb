class AddSwitchPermission < ActiveRecord::Migration
  def self.up
    Role.find(2).permissions << Permission.create('name' => 
      'students/switch_study')
  end

  def self.down
    permission = Permission.find_by_name('students/switch_study')
    Role.find(2).permissions.delete(permission)
    permission.destroy
  end
end
