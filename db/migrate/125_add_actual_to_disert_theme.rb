class AddActualToDisertTheme < ActiveRecord::Migration
  def self.up
    add_column :disert_themes, :actual, :integer
    Index.find(:all).each do |i|
      i.disert_theme.update_attribute(:actual, 1) if i.disert_theme
    end
  end

  def self.down
    remove_column :disert_themes, :actual
  end
end
