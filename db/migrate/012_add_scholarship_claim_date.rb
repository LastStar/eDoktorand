class AddScholarshipClaimDate < ActiveRecord::Migration
  def self.up
    add_column :indices, :scholarship_claim_date, :datetime
  end

  def self.down
    remove_column :indices, :scholarship_claim_date
  end
end
