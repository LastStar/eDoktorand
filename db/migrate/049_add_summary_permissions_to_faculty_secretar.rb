class AddSummaryPermissionsToFacultySecretar < ActiveRecord::Migration
  def self.up
    p = Permission.create(:name => 'candidates/summary')
    Role.find(2).permissions << p
  end

  def self.down
    p = Permission.find_by_name('candidates/summary')
    Role.find(2).permissions.delete(p)
    p.destroy
  end
end
