class ChangeCommissionType < ActiveRecord::Migration
  def self.up
    change_column :scholarships, :commission_head, :string
    change_column :scholarships, :commission_tail, :string
    change_column :scholarships, :commission_body, :string
  end

  def self.down
    change_column :scholarships, :commission_head, :integer
    change_column :scholarships, :commission_tail, :integer
    change_column :scholarships, :commission_body, :integer
  end
end
