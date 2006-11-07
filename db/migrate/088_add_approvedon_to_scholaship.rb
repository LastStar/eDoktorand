class AddApprovedonToScholaship < ActiveRecord::Migration
  def self.up
    add_column :scholarships, :approved_on, :datetime
  end

  def self.down
    remove_column :scholarships, :approved_on 
  end
end
