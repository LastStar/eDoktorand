class AddExamTermType < ActiveRecord::Migration
  def self.up
    add_column :exam_terms, :type, :string
    ExamTerm.find(:all).each {|q| q.update_attribute('type', 'AdmissionTerm')}
  end

  def self.down
    remove_column :exam_terms, :type
  end
end
