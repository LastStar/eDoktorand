class AddDepartmentSecretaryRolesToCandidates < ActiveRecord::Migration
  def self.up
    Role.find_by_name("department_secretary").permissions << Permission.find_by_name('candidates/list')
  end

  def self.down
    Role.find_by_name("department_secretary").permissions.delete(Permission.find_by_name('candidates/list'))
  end
end
