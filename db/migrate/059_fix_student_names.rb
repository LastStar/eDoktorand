require 'csv_loader'
class FixStudentNames < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute('SET NAMES UTF8')
    CSVLoader.load_name_fix('dumps/csv/fix_names.csv')
  end

  def self.down
  end
end
