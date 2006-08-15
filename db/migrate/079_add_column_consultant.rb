class AddColumnConsultant < ActiveRecord::Migration
  def self.up
    add_column :indices, :consultant, :string
  end

  def self.down
    remove_column :indices, :consultant
  end
end
