class AddDestroyPermissionToDepartmentSecretary < ActiveRecord::Migration
  def self.up
    Role.find(7).permissions <<
      Permission.create(:name => 'probation_terms/destroy')
  end

  def self.down
   Role.find(7).permissions.delete
      Permission.find_by_name('probation_terms/destroy')
  end
end
