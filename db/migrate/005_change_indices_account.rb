class ChangeIndicesAccount < ActiveRecord::Migration
  def self.up
    change_column :indices, :account_number_prefix, :string
    change_column :indices, :account_number, :string
  end

  def self.down
    change_column :indices, :account_number_prefix, :integer
    change_column :indices, :account_number, :integer
  end
end
