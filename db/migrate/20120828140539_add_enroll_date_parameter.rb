class AddEnrollDateParameter < ActiveRecord::Migration
  def self.up
    Faculty.all.each {|f| puts Parameter.create(:faculty => f, :name => 'enroll_date').valid? }
  end

  def self.down
    Parameter.all(:conditions => {:name => 'enroll_date'})
  end
end
