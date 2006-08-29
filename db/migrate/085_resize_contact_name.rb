class ResizeContactName < ActiveRecord::Migration
  def self.up
    change_column :contacts, :name, :string, :limit => 50
  end

  def self.down
    change_column :contacts, :name, :string, :limit => 20
  end
end
