class RenameInteruptToInterrupt < ActiveRecord::Migration
  def self.up
    rename_table :interupts, :study_interrupts
    rename_column :indices, :interupted_on, :interrupted_on
  end

  def self.down
    rename_table :study_interrupts, :interupts
    rename_column :indices, :interrupted_on, :interupted_on
  end
end
