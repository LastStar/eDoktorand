class AddScholarshipAddingPermission < ActiveRecord::Migration
  def self.up
    Role.find(2).permissions << Permission.create('name' => 'scholarships/search_to_add')

  end

  def self.down
    permission = Permission.find_by_name('scholarships/search_to_add')
    Role.find(2).permissions.delete(permission)
    permission.destroy
  end
end
