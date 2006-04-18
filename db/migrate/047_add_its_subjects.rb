require 'csv_loader'
class AddItsSubjects < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute('SET NAMES UTF8')
    CSVLoader.load_subjects('dumps/csv/subjects_ITS_II.csv')
  end

  def self.down
    Subject.find(9538, 9589, 9594).each {|s| s.destroy}
  end
end
