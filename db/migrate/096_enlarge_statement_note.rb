class EnlargeStatementNote < ActiveRecord::Migration
  def self.up
    change_column :statements, :note, :string, :limit => 1023
  end

  def self.down
    change_column :statements, :note, :string, :limit => 100
  end
end
