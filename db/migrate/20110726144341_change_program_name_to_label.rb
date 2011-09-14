class ChangeProgramNameToLabel < ActiveRecord::Migration
  def self.up
    rename_column :programs, :label, :name
    rename_column :programs, :label_en, :name_english
  end

  def self.down
    rename_column :programs, :name, :label
    rename_column :programs, :name_english, :label_en
  end
end
