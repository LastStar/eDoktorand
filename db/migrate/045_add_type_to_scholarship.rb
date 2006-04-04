class AddTypeToScholarship < ActiveRecord::Migration
  def self.up
    add_column :scholarships, :type, :string
  end

  def self.down
    remove_column :scholarships, :type 
  end
end
