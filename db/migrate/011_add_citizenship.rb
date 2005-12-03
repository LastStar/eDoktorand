class AddCitizenship < ActiveRecord::Migration
  def self.up
    add_column :people, :citizenship, :string
  end

  def self.down
    remove_column :people, :citizenship
  end
end
