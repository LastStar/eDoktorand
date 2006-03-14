class AddInteruptEnd < ActiveRecord::Migration
  def self.up
    add_column :interupts, :ended_on, :datetime
  end

  def self.down
    remove_column :interupts, :ended_on
  end
end
