class FinalExamTerm < ActiveRecord::Migration
  def self.up
    add_column :exam_terms, :fifth_examinator, :string
    add_column :exam_terms, :sixth_examinator, :string
    add_column :exam_terms, :opponent, :string
    add_column :exam_terms, :first_subject, :string
    add_column :exam_terms, :second_subject, :string
    add_column :exam_terms, :third_subject, :string
    add_column :exam_terms, :fourth_subject, :string
    add_column :exam_terms, :fifth_subject, :string
    add_column :exam_terms, :sixth_subject, :string
  
  end

  def self.down
    remove_column :exam_terms, :fifth_examinator
    remove_column :exam_terms, :sixth_examinator
    remove_column :exam_terms, :opponent    
    remove_column :exam_terms, :first_subject    
    remove_column :exam_terms, :second_subject    
    remove_column :exam_terms, :third_subject    
    remove_column :exam_terms, :fourth_subject    
    remove_column :exam_terms, :fifth_subject    
    remove_column :exam_terms, :sixth_subject   

    end
end
