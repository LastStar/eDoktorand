class EnlargeDisertTitle < ActiveRecord::Migration
  def self.up
    change_column :disert_themes, :title, :string, :limit => 1023
    change_column :disert_themes, :title_en, :string, :limit => 1023
  end

  def self.down
    change_column :disert_themes, :title, :string, :limit => 255
    change_column :disert_themes, :title_en, :string, :limit => 255
  end
end
