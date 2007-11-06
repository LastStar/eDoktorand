class AddPermissionToFacultySecretaryOnCoridorsAttestation < ActiveRecord::Migration
  def self.up
    Permission.find_by_name('coridors/manage_coridor').update_attribute(:name, 'coridors/index')
    Permission.find_by_name('coridors/manage_edit').update_attribute(:name, 'coridors/subjects')
    Role.find(2).permissions <<
      Permission.create(:name => 'coridors/attestation')
  end

  def self.down
  Role.find(2).permissions.delete
      Permission.find_by_name('coridors/attestation')
  end
end
