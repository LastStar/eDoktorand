class AddPermissionsScholarshipChanges < ActiveRecord::Migration
  def self.up
    Role.find(2).permissions << Permission.create('name' => 'scholarships/save')
    Role.find(2).permissions << Permission.create('name' => 'scholarships/add')
    Role.find(2).permissions << Permission.create('name' => 'scholarships/edit')
    Role.find(2).permissions << Permission.create('name' => 'scholarships/destroy')
    Role.find(2).permissions << Permission.create('name' => 'scholarships/pay')
  end

  def self.down
    p = Permission.find_by_name('scholarships/save')
    Role.find(2).permissions.delete(p)
    p.destroy
    p = Permission.find_by_name('scholarships/add')
    Role.find(2).permissions.delete(p)
    p.destroy
    p = Permission.find_by_name('scholarships/edit')
    Role.find(2).permissions.delete(p)
    p.destroy
    p = Permission.find_by_name('scholarships/destroy')
    Role.find(2).permissions.delete(p)
    p.destroy
    p = Permission.find_by_name('scholarships/pay')
    Role.find(2).permissions.delete(p)
    p.destroy
  end
end
