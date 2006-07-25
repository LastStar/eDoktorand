class AddPermissionsForScholarshipSum < ActiveRecord::Migration
  def self.up
    Role.find(2).permissions <<
      Permission.create(:name => 'scholarships/sum')
  end

  def self.down
    per = Permission.find_by_name('scholarships/sum')
    Role.find(2).permissions.delete(per)
    per.destroy
  end
end
