class AddCommissionEmailsToExamTerm < ActiveRecord::Migration
  def self.up
    add_column :exam_terms, :first_examinator_email, :string
    add_column :exam_terms, :second_examinator_email, :string
    add_column :exam_terms, :third_examinator_email, :string
    add_column :exam_terms, :fourth_examinator_email, :string
    add_column :exam_terms, :fifth_examinator_email, :string
    add_column :exam_terms, :sixth_examinator_email, :string
    add_column :exam_terms, :seventh_examinator_email, :string
    add_column :exam_terms, :eight_examinator_email, :string
    add_column :exam_terms, :nineth_examinator_email, :string
    add_column :exam_terms, :opponent_email, :string
    add_column :exam_terms, :second_opponent_email, :string
    add_column :exam_terms, :third_opponent_email, :string
  end

  def self.down
    remove_column :exam_terms, :first_examinator_email
    remove_column :exam_terms, :second_examinator_email
    remove_column :exam_terms, :third_examinator_email
    remove_column :exam_terms, :fourth_examinator_email
    remove_column :exam_terms, :fifth_examinator_email
    remove_column :exam_terms, :sixth_examinator_email
    remove_column :exam_terms, :seventh_examinator_email
    remove_column :exam_terms, :eight_examinator_email
    remove_column :exam_terms, :nineth_examinator_email
    remove_column :exam_terms, :opponent_email
    remove_column :exam_terms, :second_opponent_email
    remove_column :exam_terms, :third_opponent_email
  end
end
