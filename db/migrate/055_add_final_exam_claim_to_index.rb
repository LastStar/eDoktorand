class AddFinalExamClaimToIndex < ActiveRecord::Migration
  def self.up
    add_column :indices, :final_application_claimed_at, :datetime
  end

  def self.down
    remove_column :indices, :final_application_claimed_at
  end
end
