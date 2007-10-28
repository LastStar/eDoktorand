class AddVoluntarySubjectAmountToCoridor < ActiveRecord::Migration
  def self.up
    add_column :coridors, :voluntary_amount, :integer
  end

  def self.down
    remove_column :coridors, :voluntary_amount
  end
end
