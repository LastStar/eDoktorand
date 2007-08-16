class AddSubjectIdIndexToPlanSubject < ActiveRecord::Migration
  def self.up
    add_index :plan_subjects, :subject_id
  end

  def self.down
    remove_index :plan_subjects, :subject_id
  end
end
