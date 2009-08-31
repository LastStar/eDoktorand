class AddChairmanNameFinalExamTerm < ActiveRecord::Migration
  def self.up
     add_column :exam_terms, :chairman_name, :string

  end

  def self.down
     remove_column :exam_terms, :chairman_name
  end
end
