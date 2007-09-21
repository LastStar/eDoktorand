class AddPermissionToLeaderForScholarship < ActiveRecord::Migration
  def self.up
    Role.find(6).permissions <<
      Permission.create(:name => 'scholarships/list')
    Role.find(6).permissions <<
      Permission.create(:name => 'scholarships/next_action_for')
    Role.find(6).permissions <<
      Permission.create(:name => 'scholarships/index')
  end

  def self.down
  Role.find(6).permissions.delete
      Permission.find_by_name('scholarships/list')
  Role.find(6).permissions.delete
      Permission.find_by_name('scholarships/next_action_for')
  Role.find(6).permissions.delete
      Permission.find_by_name('scholarships/index')
  end
end
