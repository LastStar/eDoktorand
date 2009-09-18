class AddPermissionsToDeanForTutorsActualities < ActiveRecord::Migration
  def self.up
    Role.find(5).permissions <<
    Permission.find_by_name('actualities/index')
    Role.find(5).permissions <<
    Permission.find_by_name('tutors/index')
    Role.find(5).permissions <<
    Permission.find_by_name('actualities/show')
 end

  def self.down
    permission = Permission.find_by_name('actualities/index')
    Role.find(5).permissions.delete(permission)
    permission = Permission.find_by_name('tutors/index')
    Role.find(5).permissions.delete(permission)
    permission = Permission.find_by_name('actualities/show')
    Role.find(5).permissions.delete(permission)
  end
end
