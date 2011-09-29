class AddStartStudyDateToIndex < ActiveRecord::Migration
  def self.up
    add_column :indices, :study_start_on, :date
  end

  def self.down
    remove_column :indices, :study_start_on
  end
end
