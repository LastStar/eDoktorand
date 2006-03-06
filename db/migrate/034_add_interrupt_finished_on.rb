class AddInterruptFinishedOn < ActiveRecord::Migration
  def self.up
    add_column :interupts, :finished_on, :datetime
  end

  def self.down
    remove_column :interupts, :finished_on
  end
end
