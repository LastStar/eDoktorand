class AddFileChangesPermissions < ActiveRecord::Migration
  def self.up
    %w(update_disert_theme update_self_report update_literature_review).each do |p|
      Role.find(2).permissions << Permission.create(:name => "disert_themes/#{p}")
    end
  end

  def self.down
    %w(update_disert_theme update_self_report update_literature_review).each do |p|
      p = Permission.first(:conditions => {:name => "disert_themes/#{p}"})
      Role.find(2).permissions.delete p
      p.destroy
    end
  end
end
