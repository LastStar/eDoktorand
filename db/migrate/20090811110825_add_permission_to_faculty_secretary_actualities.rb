class AddPermissionToFacultySecretaryActualities < ActiveRecord::Migration
  def self.up
    Role.find(2).permissions <<
    Permission.create('name' => 'actualities/show')
    Role.find(2).permissions <<
    Permission.create('name' => 'actualities/new')
    Role.find(2).permissions <<
    Permission.create('name' => 'actualities/edit')
    Role.find(2).permissions <<
    Permission.create('name' => 'actualities/list')
    Role.find(2).permissions <<
    Permission.create('name' => 'actualities/index')
    Role.find(2).permissions <<
    Permission.create('name' => 'actualities/create')
    Role.find(2).permissions <<
    Permission.create('name' => 'actualities/update')
    Role.find(2).permissions <<
    Permission.create('name' => 'actualities/destroy')

  end

  def self.down
    permission = Permission.find_by_name('actualities/show')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('actualities/new')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('actualities/list')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('actualities/index')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('actualities/edit')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('actualities/create')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('actualities/update')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('actualities/destroy')
    Role.find(2).permissions.delete(permission)
    permission.destroy
  end
end
