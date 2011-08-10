class AddQuestionsAndDiscussionToFinalExamTerm < ActiveRecord::Migration
  def self.up
    add_column :exam_terms, :questions, :text
    add_column :exam_terms, :discussion, :text
  end

  def self.down
    remove_column :exam_terms, :discussion
    remove_column :exam_terms, :questions
  end
end
