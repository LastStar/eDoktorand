class AddStudyLengthToCoridor < ActiveRecord::Migration
  def self.up
    add_column :coridors, :study_length, :integer
  end

  def self.down
    remove_column :coridors, :study_length
  end
end
