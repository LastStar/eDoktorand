class AddPermissionToStudent < ActiveRecord::Migration
  def self.up
    Role.find(3).permissions <<
      Permission.create(:name => 'scholarships/student_list')
  end

  def self.down
    Permission.find_by_name('scholarships/student_list').destroy
  end
end
