class CreateDiplomaSupplements < ActiveRecord::Migration
  def self.up
    create_table :diploma_supplements do |t|
      t.column 'diploma_no', :integer
      t.column 'faculty_name_en', :string
      t.column 'family_name', :string
      t.column 'given_name', :string
      t.column 'date_of_birth', :string
      t.column 'study_programme', :string
      t.column 'study_specialization', :string
      t.column 'faculty_name', :string
      t.column 'study_mode', :string
      t.column 'plan_subjects', :string
      t.column 'disert_theme_title', :string
      t.column 'defense_passed_on', :string
      t.column 'final_areas', :string
      t.column 'final_exam_passed_on', :string
      t.column 'faculty_www', :string
      t.column 'printed_on', :string
      t.column 'dean_display_name', :string
      t.column 'dean_title', :string
      t.column 'printed_at', :datetime
      t.column 'created_at', :datetime
      t.column 'updated_at', :datetime
    end
  end

  def self.down
    drop_table :diploma_supplements
  end
end
