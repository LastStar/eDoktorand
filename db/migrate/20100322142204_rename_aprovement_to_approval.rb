class RenameAprovementToApproval < ActiveRecord::Migration
  def self.up
    rename_table :approvements, :approvals
  end

  def self.down
    rename_table :approvals, :approvements
  end
end
