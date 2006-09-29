class AddEnTitleToDisert < ActiveRecord::Migration
  def self.up
    add_column :disert_themes, :title_en, :string
  end

  def self.down
    remove_column :disert_themes, :title_en
  end
end
