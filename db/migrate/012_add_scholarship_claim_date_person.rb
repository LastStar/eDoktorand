class AddScholarshipClaimDatePerson < ActiveRecord::Migration
  def self.up
    add_column :people, :scholarship_claim_date, :datetime
  end

  def self.down
    remove_column :people, :scholarship_claim_date
  end
end
