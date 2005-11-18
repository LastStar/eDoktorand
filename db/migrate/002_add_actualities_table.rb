class AddActualitiesTable < ActiveRecord::Migration
  def self.up
    create_table :actualities do |table|
      table.column :label, :string
      table.column :content,  :text
    end
  end

  def self.down
    drop_table :actualities
  end
end
