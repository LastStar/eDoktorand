class AddIndices < ActiveRecord::Migration
  def self.up
    add_index :roles_permissions, :roles_id
    add_index :roles_users, :user_id
    add_index :employments, :person_id
    add_index :departments, :faculty_id
  end

  def self.down
    remove_index :roles_permissions, :roles_id
    remove_index :roles_users, :user_id
    remove_index :employments, :person_id
    remove_index :departments, :faculty_id
  end
end
