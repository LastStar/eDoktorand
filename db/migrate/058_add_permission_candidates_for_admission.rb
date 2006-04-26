class AddPermissionCandidatesForAdmission < ActiveRecord::Migration
  def self.up
    Role.find(2).permissions << Permission.create('name' => 'candidates/list_admission_ready')
  end

  def self.down
    p = Permission.find_by_name('candidates/list_admission_ready')
    Role.find(2).permissions.delete(p)
    p.destroy
  end
end
