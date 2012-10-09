class AddStartOnDayToStudyInterrupt < ActiveRecord::Migration
  def self.up
    add_column :study_interrupts, :start_on_day, :boolean
    remove_column :study_interrupts, :duration_in_days
  end

  def self.down
    remove_column :study_interrupts, :start_on_day
    add_column :study_interrupts, :duration_in_days, :boolean
  end
end
