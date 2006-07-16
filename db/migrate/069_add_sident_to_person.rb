require 'csv_loader'
class AddSidentToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :sident, :integer
    CSVLoader.load_sident('dumps/csv/students_uic_sident.csv')
  end

  def self.down
    remove_column :people, :sident
  end
end
