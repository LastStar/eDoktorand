class AddMaritalStatusToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :marital_status, :string
  end

  def self.down
    remove_column :people, :marital_status
  end
end
