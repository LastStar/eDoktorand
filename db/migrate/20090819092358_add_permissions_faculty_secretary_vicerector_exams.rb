class AddPermissionsFacultySecretaryVicerectorExams < ActiveRecord::Migration
  def self.up
    Role.find(2).permissions <<
    Permission.create('name' => 'exams/edit')
    Role.find(2).permissions <<
    Permission.create('name' => 'exams/update')
    Role.find(2).permissions <<
    Permission.create('name' => 'exams/list')
    
    Role.find(8).permissions <<
    Permission.create('name' => 'exams/edit')
    Role.find(8).permissions <<
    Permission.create('name' => 'exams/update')
    Role.find(8).permissions <<
    Permission.create('name' => 'exams/list')    

  end

  def self.down
    permission = Permission.find_by_name('exams/edit')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('exams/update')
    Role.find(2).permissions.delete(permission)
    permission.destroy
      permission = Permission.find_by_name('exams/list')
    Role.find(2).permissions.delete(permission)
    permission.destroy
      
     permission = Permission.find_by_name('exams/edit')
    Role.find(8).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('exams/update')
    Role.find(8).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('exams/list')
    Role.find(8).permissions.delete(permission)
    permission.destroy

    
  end
end
