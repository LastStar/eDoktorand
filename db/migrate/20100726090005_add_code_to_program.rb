class AddCodeToProgram < ActiveRecord::Migration
  def self.up
    add_column :programs, :code, :string
  end

  def self.down
    remove_column :programs, :code
  end
end
