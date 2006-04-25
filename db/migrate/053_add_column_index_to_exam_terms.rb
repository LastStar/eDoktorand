class AddColumnIndexToExamTerms < ActiveRecord::Migration
  def self.up
    add_column :exam_terms, :index_id, :integer
  end

  def self.down
    remove_column :exam_terms, :index_id
  end
end
