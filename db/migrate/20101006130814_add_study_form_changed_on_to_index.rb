class AddStudyFormChangedOnToIndex < ActiveRecord::Migration
  def self.up
    add_column :indices, :study_form_changed_on, :date
  end

  def self.down
    remove_column :indices, :study_form_changed_on
  end
end
