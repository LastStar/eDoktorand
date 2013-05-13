class AddLeaderPermissionToCandidates < ActiveRecord::Migration
  def self.up
    Role.find_by_name("leader").permissions << Permission.find_by_name("candidates/list")
  end

  def self.down
    Role.find_by_name("leader").permissions.delete(Permission.find_by_name("candidates/list"))
  end
end
