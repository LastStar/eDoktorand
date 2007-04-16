class AddEnglishNameToStudies < ActiveRecord::Migration
  def self.up
    add_column :studies, :name_en, :string
  end

  def self.down
    remove_column :studies, :name_en
  end
end
