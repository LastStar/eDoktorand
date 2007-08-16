class AddPermissionToFacultySecretaryOnCandidate < ActiveRecord::Migration
  def self.up
    Role.find(2).permissions <<
      Permission.create(:name => 'candidates/admit_for_revocation')
  end

  def self.down
  Role.find(2).permissions.delete
      Permission.find_by_name('candidates/admit_for_revocation')
  end
end
