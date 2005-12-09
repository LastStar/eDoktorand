class ChangeBankCodeToString < ActiveRecord::Migration
  def self.up
    change_column :indices, :account_bank_number, :string
  end

  def self.down
    change_column :indices, :account_bank_number, :integer
  end
end
