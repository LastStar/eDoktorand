class RemoveSurnameColumn < ActiveRecord::Migration
  def self.up
    remove_column :people, :surname
  end

  def self.down
     add_column :people, :surname, :string
  end
end
