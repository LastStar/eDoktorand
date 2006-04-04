class AddScholarshipPermissionsToFacultySecretary < ActiveRecord::Migration
  def self.up
    Permission.create('name' => 'scholarships/prepare')
    Permission.create('name' => 'scholarships/change')
    Role.find(2).permissions << Permission.find_by_name('scholarships/prepare')
    Role.find(2).permissions << Permission.find_by_name('scholarships/change')

  end

  def self.down
    Permission.find_by_name('scholarships/prepare').destroy
    Permission.find_by_name('scholarships/change').destroy
  end
end
