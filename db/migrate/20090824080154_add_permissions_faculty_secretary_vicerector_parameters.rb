class AddPermissionsFacultySecretaryVicerectorParameters < ActiveRecord::Migration
  def self.up
    
    Role.find(2).permissions <<
    Permission.create('name' => 'parameters/list')
    Role.find(2).permissions <<
    Permission.create('name' => 'parameters/edit')
    Role.find(2).permissions <<
    Permission.create('name' => 'parameters/new')
    Role.find(2).permissions <<
    Permission.create('name' => 'parameters/index')
    Role.find(2).permissions <<
    Permission.create('name' => 'parameters/create')
    Role.find(2).permissions <<
    Permission.create('name' => 'parameters/show')
    Role.find(2).permissions <<
    Permission.create('name' => 'parameters/update')
    Role.find(2).permissions <<
    Permission.create('name' => 'parameters/sample_page')
      
    Role.find(8).permissions <<
    Permission.create('name' => 'parameters/list')
    Role.find(8).permissions <<
    Permission.create('name' => 'parameters/edit')
    Role.find(8).permissions <<
    Permission.create('name' => 'parameters/new')
    Role.find(2).permissions <<
    Permission.create('name' => 'parameters/index')
    Role.find(8).permissions <<
    Permission.create('name' => 'parameters/create')
    Role.find(8).permissions <<
    Permission.create('name' => 'parameters/show')
    Role.find(8).permissions <<
    Permission.create('name' => 'parameters/update')
    Role.find(8).permissions <<
    Permission.create('name' => 'parameters/sample_page')
  end

  def self.down 
    
    permission = Permission.find_by_name('parameters/list')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('parameters/edit')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('parameters/new')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('parameters/index')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('parameters/create')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('parameters/show')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('parameters/update')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('parameters/sample_page')
    Role.find(2).permissions.delete(permission)
    permission.destroy

      
    permission = Permission.find_by_name('parameters/list')
    Role.find(8).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('parameters/edit')
    Role.find(8).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('parameters/new')
    Role.find(8).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('parameters/index')
    Role.find(8).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('parameters/create')
    Role.find(8).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('parameters/show')
    Role.find(8).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('parameters/update')
    Role.find(8).permissions.delete(permission)
    permission.destroy 
    permission = Permission.find_by_name('parameters/sample_page')
    Role.find(8).permissions.delete(permission)
    permission.destroy
        
  end
end
