class AddFacultySecretaryRigthsToPostalAddressEdit < ActiveRecord::Migration
  def self.up
    %w(edit_postal_street edit_postal_zip edit_postal_desc_number edit_postal_city
      save_postal_street save_postal_zip save_postal_desc_number save_postal_city).each do |p|
      Role.find(2).permissions << Permission.create(:name => "students/#{p}")
    end
  end

  def self.down
    %w(edit_postal_street edit_postal_zip edit_postal_desc_number edit_postal_city
      save_postal_street save_postal_zip save_postal_desc_number save_postal_city).each do |p|
      p = Permission.first(:conditions => {:name => "students/#{p}"})
      Role.find(2).permissions.delete p
      p.destroy
    end
  end
end
