class AddThirdFourthExaminator < ActiveRecord::Migration
  def self.up
    add_column :exams, :third_examinator_id, :integer
    add_column :exams, :fourth_examinator_id, :integer
  end

  def self.down
    remove_column :exams, :third_examinator_id
    remove_column :exams, :fourth_examinator_id
  end
end
