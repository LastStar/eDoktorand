class AddMsmtCodeToSpecialization < ActiveRecord::Migration
  def self.up
    add_column :specializations, :msmt_code, :string
  end

  def self.down
    remove_column :specializations, :msmt_code
  end
end
