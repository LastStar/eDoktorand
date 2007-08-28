class EnlargeAddressCityAndState < ActiveRecord::Migration
  def self.up
    change_column :addresses, :city, :limit => 100
    change_column :addresses, :state, :limit => 100
  end

  def self.down
    change_column :addresses, :city, :limit => 20
    change_column :addresses, :state, :limit => 20
  end
end
