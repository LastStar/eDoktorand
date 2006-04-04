class RenameScholarshipClaimDate < ActiveRecord::Migration
  def self.up
    rename_column :people, :scholarship_claim_date, :scholarship_claimed_at
  end

  def self.down
    rename_column :people, :scholarship_claimed_at, :scholarship_claim_date
  end
end
