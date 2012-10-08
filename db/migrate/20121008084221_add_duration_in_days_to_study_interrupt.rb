class AddDurationInDaysToStudyInterrupt < ActiveRecord::Migration
  def self.up
    add_column :study_interrupts, :duration_in_days, :boolean
  end

  def self.down
    remove_column :study_interrupts, :duration_in_days
  end
end
