class AddApprovementDatesToIndex < ActiveRecord::Migration
  def self.up
    add_column :indices, :approved_on, :datetime
    add_column :indices, :canceled_on, :datetime
  end

  def self.down
    remove_column :indices, :approved_on
    remove_column :indices, :canceled_on
  end
end
