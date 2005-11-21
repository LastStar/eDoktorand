class AddScholarshipTable < ActiveRecord::Migration
  def self.up
    create_table :scholarships do |table|
      table.column :label, :string
      table.column :content,  :text
      table.column :index_id, :integer
      table.column :amount, :float
      table.column :commission_head, :integer
      table.column :commission_body, :integer
      table.column :commission_tail, :integer
      table.column :payed_on, :datetime
      table.column :created_on, :datetime
      table.column :updated_on, :datetime
      table.column :created_by_id, :integer
      table.column :update_by_id, :integer
    end
    add_column :indices, :account_number_prefix, :integer
    add_column :indices, :account_number, :integer
    add_column :indices, :account_bank_number, :integer
  end
  def self.down
    drop_table :scholarships
    remove_column :indices, :account_number_prefix
    remove_column :indices, :account_number
    remove_column :indices, :account_bank_number
  end
end
