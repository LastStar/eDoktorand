class AddPermissionsForTutorShipToFacultySecretary < ActiveRecord::Migration
  def self.up
    Role.find(2).permissions <<
      Permission.create(:name => 'tutors/index')
    Role.find(2).permissions <<
      Permission.create(:name => 'tutors/list')
    Role.find(2).permissions <<
      Permission.create(:name => 'tutors/edit')
    Role.find(2).permissions <<
      Permission.create(:name => 'tutors/save_coridor')

  end

  def self.down
   Role.find(2).permissions.delete
      Permission.find_by_name('tutors/index')
   Role.find(2).permissions.delete
      Permission.find_by_name('tutors/list')
   Role.find(2).permissions.delete
      Permission.find_by_name('tutors/edit')
   Role.find(2).permissions.delete
      Permission.find_by_name('tutors/save_coridor')

  end
end
