class MoveAccountChangePermissions < ActiveRecord::Migration
  def self.up
    Role.find(3).permissions.delete
      Permission.find_by_name('scholarships/account_change').destroy
    Role.find(3).permissions.delete
      Permission.find_by_name('scholarships/save_account').destroy
    Role.find(3).permissions << Permission.create('name' => 
                                                  'students/save_account')
    Role.find(3).permissions << Permission.create('name' =>
                                                  'students/edit_account')
  end

  def self.down
    Role.find(3).permissions.delete
      Permission.find_by_name('student/save_account').destroy
    Role.find(3).permissions.delete
      Permission.find_by_name('students/edit_account').destroy
  end
end
