class AddStudyFormChangedOnToImIndex < ActiveRecord::Migration
  def self.up
    add_column :im_indices, :study_form_changed_on, :date
  end

  def self.down
    remove_column :im_indices, :study_form_changed_on
  end
end
