class AddPermissionsToFacultySecretaryForCoridor < ActiveRecord::Migration
  def self.up
    Role.find(2).permissions <<
      Permission.create(:name => 'coridors/manage_coridor')
    Role.find(2).permissions <<
      Permission.create(:name => 'coridors/manage_edit')
    Role.find(2).permissions <<
      Permission.create(:name => 'coridors/del_subject')
    Role.find(2).permissions <<
      Permission.create(:name => 'coridors/add_subject')
    Role.find(2).permissions <<
      Permission.create(:name => 'coridors/save_subject')

  end

  def self.down
  Role.find(2).permissions.delete
      Permission.find_by_name('coridors/manage_coridor')
  Role.find(2).permissions.delete
      Permission.find_by_name('coridors/manage_edit')
  Role.find(2).permissions.delete
      Permission.find_by_name('coridors/del_subject')
  Role.find(2).permissions.delete
      Permission.find_by_name('coridors/add_subject')
  Role.find(2).permissions.delete
      Permission.find_by_name('coridors/save_subject')

  end
end
