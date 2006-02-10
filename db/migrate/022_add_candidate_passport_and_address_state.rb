class AddCandidatePassportAndAddressState < ActiveRecord::Migration
  def self.up
    add_column :candidates, :address_state, :string, :limit => 240
    add_column :candidates, :postal_state, :string, :limit => 240
  end

  def self.down
    remove_column :candidates, :address_state
    remove_column :candidates, :postal_state
  end
end
