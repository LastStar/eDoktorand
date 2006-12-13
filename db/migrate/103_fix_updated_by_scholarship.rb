class FixUpdatedByScholarship < ActiveRecord::Migration
  def self.up
    rename_column :scholarships, :update_by_id, :updated_by_id
  end

  def self.down
    rename_column :scholarships, :updated_by_id, :update_by_id
  end
end
