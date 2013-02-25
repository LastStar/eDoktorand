class AddFacultySecretaryRigthsToStudentScholarships < ActiveRecord::Migration
  def self.up
    Role.find(2).permissions << Permission.create(:name => "scholarships/secretary_list")
  end

  def self.down
    p = Permission.first(:conditions => {:name => "scholarships/secretary_list"})
    Role.find(2).permissions.delete(p)
    p.destroy
  end
end
