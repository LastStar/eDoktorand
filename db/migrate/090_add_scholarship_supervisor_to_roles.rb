class AddScholarshipSupervisorToRoles < ActiveRecord::Migration
  def self.up
    Role.create(:name => "supervisor")
    Role.find_by_name("supervisor").permissions << Permission.find_by_name('scholarships/pay')
    Role.find_by_name("supervisor").permissions << Permission.find_by_name('account/welcome')
    Role.find_by_name("supervisor").permissions << Permission.find_by_name('account/logout')
    Role.find_by_name("supervisor").permissions << Permission.find_by_name('scholarships/list')
  end

  def self.down
    Role.find_by_name("supervisor").destroy
  end
end
