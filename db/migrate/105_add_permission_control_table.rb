class AddPermissionControlTable < ActiveRecord::Migration
  def self.up
    Role.find(2).permissions <<
      Permission.create(:name => 'scholarships/control_table')
    Role.find(7).permissions <<
      Permission.find_by_name('scholarships/control_table')
  end

  def self.down
    Permission.find_by_name('scholarships/control_table').destroy
  end
end
