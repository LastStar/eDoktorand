class ChangePermissionsFromCoridorsToSpecializations < ActiveRecord::Migration
  def self.up
    permissions = Permission.find(:all, :conditions => "name like 'coridors/%'")
    permissions.each do |permission|
      permission.update_attribute(:name, permission.name.gsub(/coridors/, 'specializations'))
    end
  end

  def self.down
    permissions = Permission.find(:all, :conditions => "name like 'specializations/%'")
    permissions.each do |permission|
      permission.update_attribute(:name, permission.name.gsub(/specializations/, 'coridors'))
    end
  end
end
