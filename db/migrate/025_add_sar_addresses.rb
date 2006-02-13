class AddSarAddresses < ActiveRecord::Migration
  def self.up
    add_column :faculties, :street, :string
    # TODO add addresses to database
  end

  def self.down
    remove_column :faculties, :street, :string
  end
end
