class AddPermissionToFacultySecretarySaveMethodology < ActiveRecord::Migration
  def self.up
    Role.find(2).permissions <<
    Permission.find_by_name('disert_themes/save_methodology')
    Role.find(8).permissions <<
    Permission.find_by_name('disert_themes/save_methodology')
  end

  def self.down
    permission = Permission.find_by_name('disert_themes/save_methodology')
    Role.find(8).permissions.delete(permission)  
    permission = Permission.find_by_name('disert_themes/save_methodology')
    Role.find(2).permissions.delete(permission)  
  end
end
