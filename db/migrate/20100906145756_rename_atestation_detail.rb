class RenameAtestationDetail < ActiveRecord::Migration
  def self.up
    rename_table :atestation_details, :attestation_details
  end

  def self.down
    rename_table :attestation_details, :atestation_details
  end
end
