class AddPermissionToFacultySecretary < ActiveRecord::Migration
  def self.up
    Permission.create(:name => 'disert_themes/edit_title')
    Permission.create(:name => 'disert_themes/update_title')
    Role.find(2).permissions << Permission.find_by_name('disert_themes/edit_title')
    Role.find(2).permissions << Permission.find_by_name('disert_themes/update_title')
  end

  def self.down
    Role.find(2).permissons.delete(Permission.find_by_name('disert_themes/edit_title'))
    Role.find(2).permissons.delete(Permission.find_by_name('disert_themes/update_title'))
    Permission.find_by_name('disert_themes/edit_title').destroy
    Permission.find_by_name('disert_themes/update_title').destroy
  end
end
