class AddPermissionFacultySecretaryExaminators < ActiveRecord::Migration
  def self.up
    Role.find(2).permissions <<
    Permission.create('name' => 'examinators/index')
    Role.find(2).permissions <<
    Permission.create('name' => 'examinators/list')
    Role.find(2).permissions <<
    Permission.create('name' => 'examinators/edit')
    Role.find(2).permissions <<
    Permission.create('name' => 'examinators/update')
  end

  def self.down
    permission = Permission.find_by_name('examinators/index')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('examinators/list')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('examinators/edit')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('examinators/update')
    Role.find(2).permissions.delete(permission)
    permission.destroy  
  end
end
