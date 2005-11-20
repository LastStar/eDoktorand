class AddIndexesToIndex < ActiveRecord::Migration
  def self.up
    add_index :indices, :student_id
    add_index :indices, :department_id
    add_index :indices, :coridor_id
    add_index :indices, :tutor_id
    add_index :indices, :finished_on
    add_index :indices, :enrolled_on
  end

  def self.down
    remove_index :indices, :student_id
    remove_index :indices, :department_id
    remove_index :indices, :coridor_id
    remove_index :indices, :tutor_id
    remove_index :indices, :finished_on
    remove_index :indices, :enrolled_on
  end
end
