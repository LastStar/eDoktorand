class AddDepartmentSuccessfulToDefense < ActiveRecord::Migration
  def self.up
    add_column :exam_terms, :department_successful, :boolean
  end

  def self.down
    remove_column :exam_terms, :department_successful
  end
end
