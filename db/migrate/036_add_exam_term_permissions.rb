class AddExamTermPermissions < ActiveRecord::Migration
  def self.up
    Role.find(2).permissions << Permission.find(:all, :conditions => "name like 'exam_terms/%'")
  end

  def self.down
    Role.find(2).permissions.delete(Permission.find(:all, :conditions => "name like 'exam_terms/%'"))
  end
end
