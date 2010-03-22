class RenameCoridorToSpecialization < ActiveRecord::Migration
  def self.up
    rename_table :coridors, :specializations
    rename_table :coridor_subjects, :specialization_subjects
    rename_column :candidates, :coridor_id, :specialization_id
    rename_column :tutorships, :coridor_id, :specialization_id
    rename_column :specialization_subjects, :coridor_id, :specialization_id
    rename_column :exam_terms, :coridor_id, :specialization_id
    rename_column :indices, :coridor_id, :specialization_id
  end

  def self.down
    rename_table :specializations, :coridors
    rename_table :specialization_subjects, :coridor_subjects
    rename_column :candidates, :specialization_id, :coridor_id
    rename_column :tutorships, :specialization_id, :coridor_id
    rename_column :specialization_subjects, :specialization_id, :coridor_id
    rename_column :exam_terms, :specialization_id, :coridor_id
    rename_column :indices, :specialization_id, :coridor_id
  end
end
