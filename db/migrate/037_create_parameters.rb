class CreateParameters < ActiveRecord::Migration
  def self.up
    create_table "parameters", :force => true do |t|
      t.column "faculty_id", :integer
      t.column "name", :string, :limit => 240
      t.column "value", :text
    end
    
    Parameter.create(:faculty_id => 1, :name => 'final_areas_on', :value => 7)
    Parameter.create(:faculty_id => 1, :name => 'atestation_month', :value => 9)
    Parameter.create(:faculty_id => 1, :name => 'atestation_day', :value => 15)
    Parameter.create(:faculty_id => 2, :name => 'final_areas_on', :value => 7)
    Parameter.create(:faculty_id => 2, :name => 'atestation_month', :value => 11)
    Parameter.create(:faculty_id => 2, :name => 'atestation_day', :value => 30)
    Parameter.create(:faculty_id => 3, :name => 'final_areas_on', :value => 7)
    Parameter.create(:faculty_id => 3, :name => 'atestation_month', :value => 9)
    Parameter.create(:faculty_id => 3, :name => 'atestation_day', :value => 20)
    Parameter.create(:faculty_id => 4, :name => 'final_areas_on', :value => 8)
    Parameter.create(:faculty_id => 4, :name => 'atestation_month', :value => 1)
    Parameter.create(:faculty_id => 4, :name => 'atestation_day', :value => 31)
    Parameter.create(:faculty_id => 5, :name => 'final_areas_on', :value => 2)
    Parameter.create(:faculty_id => 5, :name => 'atestation_month', :value => 1)
    Parameter.create(:faculty_id => 5, :name => 'atestation_day', :value => 31)
  end

  def self.down
    drop_table "parameters"
  end
end
