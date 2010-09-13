class ChangeAttestationTermInDetailToDate < ActiveRecord::Migration
  def self.up
    change_column(:attestation_details, :attestation_term, :date)
  end

  def self.down
    change_column(:attestation_details, :attestation_term, :date_time)
  end
end
