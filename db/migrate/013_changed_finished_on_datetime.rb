class ChangedFinishedOnDatetime < ActiveRecord::Migration
  def self.up
    change_column :indices, :finished_on, :datetime
    change_column :indices, :interupted_on, :datetime
  end

  def self.down
    change_column :indices, :finished_on, :timestamp
    change_column :indices, :interupted_on, :timestamp
  end
end
