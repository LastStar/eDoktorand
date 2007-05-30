class AddExaminatorsToExamTerm < ActiveRecord::Migration
  def self.up
    add_column :exam_terms, :fifth_examinator, :string
    add_column :exam_terms, :sixth_examinator, :string
    add_column :exam_terms, :seventh_examinator, :string
  end

  def self.down
    remove_column :exam_terms, :fifth_examinator
    remove_column :exam_terms, :sixth_examinator
    remove_column :exam_terms, :seventh_examinator
  end
end
