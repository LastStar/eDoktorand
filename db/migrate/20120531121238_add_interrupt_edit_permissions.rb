class AddInterruptEditPermissions < ActiveRecord::Migration
  def self.up
    role = Role.find_by_name('faculty_secretary')
    role.permissions << Permission.create(:name => 'study_interrupts/edit')
    role.permissions << Permission.create(:name => 'study_interrupts/update')
  end

  def self.down
    role = Role.find_by_name('faculty_secretary')
    permission = Permission.first(:conditions => {:name => 'study_interrupts/edit'})
    role.permissions.delete(permission)
    permission.destroy
    permission = Permission.first(:conditions => {:name => 'study_interrupts/update'})
    role.permissions.delete(permission)
    permission.destroy
  end
end
