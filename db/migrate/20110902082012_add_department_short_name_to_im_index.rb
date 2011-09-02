class AddDepartmentShortNameToImIndex < ActiveRecord::Migration
  def self.up
    add_column :im_indices, :department_short_name, :string
  end

  def self.down
    remove_column :im_indices, :department_short_name
  end
end
