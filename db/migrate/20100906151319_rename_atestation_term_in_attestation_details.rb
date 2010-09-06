class RenameAtestationTermInAttestationDetails < ActiveRecord::Migration
  def self.up
    rename_column :attestation_details, :atestation_term, :attestation_term
  end

  def self.down
    rename_column :attestation_details, :attestation_term, :atestation_term
  end
end
