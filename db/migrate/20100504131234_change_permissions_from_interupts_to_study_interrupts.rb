class ChangePermissionsFromInteruptsToStudyInterrupts < ActiveRecord::Migration
  def self.up
    permissions = Permission.find(:all, :conditions => "name like 'interupts/%'")
    permissions.each do |permission|
      permission.update_attribute(:name, permission.name.gsub(/interupts/, 'study_interrupts'))
    end
  end

  def self.down
    permissions = Permission.find(:all, :conditions => "name like 'study_interrupts/%'")
    permissions.each do |permission|
      permission.update_attribute(:name, permission.name.gsub(/study_interrupts/, 'interupts'))
    end
  end
end
