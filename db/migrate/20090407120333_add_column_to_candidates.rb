class AddColumnToCandidates < ActiveRecord::Migration
  def self.up
    add_column :candidates, :foreign_pay, :boolean
  end

  def self.down
    remove_column :candidates, :foreign_pay
  end
end
