class AddStudentKey < ActiveRecord::Migration
  def self.up
    add_index :people, :lastname
  end

  def self.down
    remove_index :people, :lastname
  end
end
