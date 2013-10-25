class AddNotPassedOnToExamTerm < ActiveRecord::Migration
  def self.up
    add_column :exam_terms, :not_passed_on, :date
  end

  def self.down
    remove_column :exam_terms, :not_passed_on
  end
end
