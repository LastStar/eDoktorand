class AddCreatedUpdatedToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :created_at, :datetime
    add_column :contacts, :updated_at, :datetime    
  end

  def self.down
    remove_column :contacts, :created_at
    remove_column :contacts, :updated_at    
  end
end
