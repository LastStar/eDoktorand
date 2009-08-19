class AddPermissionFacultySecretaryTutors < ActiveRecord::Migration
 
 def self.up
    Role.find(2).permissions <<
    Permission.create('name' => 'tutors/index')
    Role.find(2).permissions <<
    Permission.create('name' => 'tutors/list')
    Role.find(2).permissions <<
    Permission.create('name' => 'tutors/edit')
    Role.find(2).permissions <<
    Permission.create('name' => 'tutors/update')
    
    Role.find(8).permissions <<
    Permission.create('name' => 'tutors/index')
    Role.find(8).permissions <<
    Permission.create('name' => 'tutors/list')
    Role.find(8).permissions <<
    Permission.create('name' => 'tutors/edit')
    Role.find(8).permissions <<
    Permission.create('name' => 'tutors/update')
  end

  def self.down
    permission = Permission.find_by_name('tutors/index')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('tutors/list')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('tutors/edit')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('tutors/update')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    
     permission = Permission.find_by_name('tutors/index')
    Role.find(8).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('tutors/list')
    Role.find(8).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('tutors/edit')
    Role.find(8).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('tutors/update')
    Role.find(8).permissions.delete(permission)
    permission.destroy  
  end
 
end
