class AddEnglishLabelToSubject < ActiveRecord::Migration
  def self.up
    add_column :subjects, :label_en, :string
  end

  def self.down
    remove_column :subjects, :label_en
  end
end
