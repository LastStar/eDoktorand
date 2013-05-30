class AddNewScholarshipsPermissions < ActiveRecord::Migration
  def self.up
    %(destroy_over).each do |action|
      Role.find(2).permissions << Permission.create(:name => "scholarships/#{action}")
    end
  end

  def self.down
    %(destroy_over).each do |action|
      p = Permission.find_by_name("scholarship/#{action}")
      Role.find(2).permissions.delete(p)
      p.destroy
    end
  end
end
