class AddInteruptToFacultySecretary < ActiveRecord::Migration
 def self.up
    Role.find(2).permissions << Permission.create('name' => 
      'interupts/index')
    Role.find(2).permissions << Permission.find_by_name('interupts/create')
    Role.find(2).permissions << Permission.find_by_name('interupts/finish')
  end

  def self.down
    permission = Permission.find_by_name('interupts/index')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('inteurpts/create')
    Role.find(2).permissions.delete(permission)
    permission = Permission.find_by_name('inteurpts/finish')
    Role.find(2).permissions.delete(permission)
  end
end
