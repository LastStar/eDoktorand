class AddLiteratureReview < ActiveRecord::Migration
  def self.up
    add_column :disert_themes, :literature_review, :string, :limit => 1023
  end

  def self.down
    remove_column :disert_themes, :literature_review
  end
end
