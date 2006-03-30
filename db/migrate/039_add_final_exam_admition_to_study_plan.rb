class AddFinalExamAdmitionToStudyPlan < ActiveRecord::Migration
  def self.up
    add_column :study_plans, :final_exam_admited_at, :datetime
  end

  def self.down
    remove_column :study_plans, :final_exam_admited_at
  end
end
