class AddIntellectualProprtyToIndex < ActiveRecord::Migration
  def self.up
    add_column :indices, :intellectual_property, :boolean
    Role.find_by_name('student').permissions << Permission.create(:name => 'study_plans/intellectual_property')
    Role.find_by_name('student').permissions << Permission.create(:name => 'study_plans/confirm_intellectual_property')
  end

  def self.down
    remove_column :indices, :intellectual_property
  end
end
