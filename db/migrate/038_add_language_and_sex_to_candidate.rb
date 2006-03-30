class AddLanguageAndSexToCandidate < ActiveRecord::Migration
  def self.up
    add_column :candidates, :language, :string
    add_column :candidates, :sex, :string
  end

  def self.down
    remove_column :candidates, :language
    remove_column :candidates, :sex
  end
end
