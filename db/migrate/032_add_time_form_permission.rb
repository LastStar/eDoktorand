class AddTimeFormPermission < ActiveRecord::Migration
  def self.up
    Role.find(2).permissions << Permission.create('name' => 'students/time_form')
  end

  def self.down
    Role.find(2).permissions.delete(Permission.find_by_name('students/time_form').destroy)
  end
end
