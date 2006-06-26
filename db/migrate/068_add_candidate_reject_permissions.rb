class AddCandidateRejectPermissions < ActiveRecord::Migration
  def self.up
    unless Permission.find_by_name('candidates/reject')
      Permission.create('name' => 'candidates/reject')
      Role.find(2).permissions << Permission.find_by_name('candidates/reject')
    end
    unless Permission.find_by_name('candidates/reject_now')
      Permission.create('name' => 'candidates/reject_now')
      Role.find(2).permissions << Permission.find_by_name('candidates/reject_now')
    end
  end

  def self.down
    Role.find(2).permissions.delete(Permission.find_by_name('candidates/reject'))
    Permission.find_by_name('candidates/reject').destroy
    Role.find(2).permissions.delete(Permission.find_by_name('candidates/reject_now'))
    Permission.find_by_name('candidates/reject_now').destroy
  end
end
