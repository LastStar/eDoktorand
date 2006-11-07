class ChangeRightsFromSecretariesOnScholarship < ActiveRecord::Migration
  def self.up
    Role.find_by_name("faculty_secretary").permissions.delete(Permission.find_by_name('scholarships/pay'))
    Role.find_by_name("faculty_secretary").permissions << Permission.create('name' => 'scholarships/approve')
    Role.find_by_name("faculty_secretary").permissions << Permission.create('name' => 'scholarships/index')
    Role.find_by_name("faculty_secretary").permissions << Permission.create('name' => 'scholarships/recalculate')
  end

  def self.down
    Role.find_by_name("faculty_secretary").permissions << Permission.find_by_name('scholarships/pay')
    Role.find_by_name("faculty_secretary").permissions.delete(Permission.find_by_name('scholarships/approve').destroy)
    Role.find_by_name("faculty_secretary").permissions.delete(Permission.find_by_name('scholarships/index').destroy)
    Role.find_by_name("faculty_secretary").permissions.delete(Permission.find_by_name('scholarships/recalculate').destroy)
  end
end
