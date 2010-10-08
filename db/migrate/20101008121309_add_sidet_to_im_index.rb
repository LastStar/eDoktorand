class AddSidetToImIndex < ActiveRecord::Migration
  def self.up
    add_column :im_indices, :sident, :integer
    remove_column :im_students, :sident
  end

  def self.down
    remove_column :im_indices, :sident
    add_column :im_students, :sident, :integer
  end
end
