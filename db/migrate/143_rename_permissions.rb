class RenamePermissions < ActiveRecord::Migration
  def self.up
    per = Permission.find_by_name('coridors/save_subject')
    per.update_attribute(:name, 'coridors/save_coridor_subject')
  end

  def self.down
    per = Permission.find_by_name('coridors/save_coridor_subject')
    per.update_attribute(:name, 'coridors/save_subject')
  end
end
