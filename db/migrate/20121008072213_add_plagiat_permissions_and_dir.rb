class AddPlagiatPermissionsAndDir < ActiveRecord::Migration
  def self.up
    permissions = [Permission.create(:name => "disert_themes/plagiat"),
                  Permission.create(:name => "disert_themes/theses_result")]
    Role.find(2, 4, 5, 6, 7, 8, 11, 12).each do |role|
      permissions.each { |per| role.permissions << per }
    end
    FileUtils.mkdir("public/pdf/thesis_result") unless File.exists?("public/pdf/thesis_result")
  end

  def self.down
    permissions = [Permission.first(:conditions => {:name => "disert_themes/plagiat"}),
                  Permission.first(:conditions => {:name => "disert_themes/theses_result"})]
    Role.find(2, 4, 5, 6, 7, 8, 11, 12).each do |role|
      permissions.each { |per| role.permissions.delete per }
    end
    permissions.each { |p| p.destroy }
    FileUtils.rm_rf("public/pdf/thesis_result")
  end
end
