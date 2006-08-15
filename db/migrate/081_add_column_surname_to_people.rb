class AddColumnSurnameToPeople < ActiveRecord::Migration
  def self.up
     add_column :people, :surname, :string
 end

  def self.down
    remove_column :people, :surname
  end
end
