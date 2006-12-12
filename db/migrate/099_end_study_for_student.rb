class EndStudyForStudent < ActiveRecord::Migration
  def self.up
    Role.find(3).permissions <<
      Permission.create(:name => 'students/end_study')
    Role.find(3).permissions <<
      Permission.create(:name => 'students/end_study_confirm')
  end

  def self.down
   Role.find(3).permissions.delete
      Permission.find_by_name('students/end_study')
   Role.find(3).permissions.delete
      Permission.find_by_name('students/end_study_confirm')

  end
end
