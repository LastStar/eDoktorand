class EnlargeAddressCityAndState < ActiveRecord::Migration
  def self.up
    change_column :addresses, :city, :string, :limit => 100
    change_column :addresses, :state, :string, :limit => 100
  end

  def self.down
    change_column :addresses, :city, :string, :limit => 20
    change_column :addresses, :state, :string, :limit => 20
  end
end
