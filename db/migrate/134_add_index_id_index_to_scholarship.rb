class AddIndexIdIndexToScholarship < ActiveRecord::Migration
  def self.up
    add_index :scholarships, :index_id
  end

  def self.down
    remove_index :scholarships, :index_id
  end
end
