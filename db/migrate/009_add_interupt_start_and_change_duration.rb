class AddInteruptStartAndChangeDuration < ActiveRecord::Migration
  def self.up
    add_column :interupts, :start_on, :datetime
    add_column :interupts, :approved_on, :datetime
    add_column :interupts, :canceled_on, :datetime
    rename_column :interupts, :interupt_duration, :duration
  end

  def self.down
    remove_column :interupts, :start_on
    remove_column :interupts, :approved_on
    remove_column :interupts, :canceled_on
    rename_column :interupts, :duration, :interupt_duration
  end
end
