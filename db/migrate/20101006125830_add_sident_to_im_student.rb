class AddSidentToImStudent < ActiveRecord::Migration
  def self.up
    add_column :im_students, :sident, :integer
  end

  def self.down
    remove_column :im_students, :sident
  end
end
