class ChangeSizeOfInteruptNote < ActiveRecord::Migration
  def self.up
    change_column :interupts, :note, :string, :limit => 512
  end

  def self.down
    change_column :interupts, :note, :string, :limit => 100
  end
end
