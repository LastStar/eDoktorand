class AddIndexIndexes < ActiveRecord::Migration
  def self.up
    add_index :disert_themes, :index_id
    add_index :interupts, :index_id
    add_index :plan_subjects, :study_plan_id
    add_index :study_plans, :index_id
  end

  def self.down
    remove_index :disert_themes, :index_id
    remove_index :interupts, :index_id
    remove_index :plan_subjects, :study_plan_id
    remove_index :study_plans, :index_id
  end
end
