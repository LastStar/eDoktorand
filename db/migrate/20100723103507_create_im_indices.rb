class CreateImIndices < ActiveRecord::Migration
  def self.up
    create_table :im_indices do |t|
      t.integer :index_id
      t.integer :student_uic
      t.string :department_name
      t.string :department_code
      t.string :faculty_name
      t.string :faculty_code
      t.integer :study_year
      t.string :academic_year
      t.string :study_type
      t.string :study_type_code
      t.string :study_form
      t.string :study_form_code
      t.string :study_spec
      t.string :study_spec_code
      t.string :study_spec_msmt_code
      t.string :study_prog
      t.string :study_prog_code
      t.string :study_status
      t.string :study_status_code
      t.date :study_status_from
      t.date :study_status_to
      t.date :enrollment_date
      t.string :financing_type
      t.integer :financing_type_code
      t.string :education_language
      t.string :education_language_code
      t.string :education_place
      t.datetime :last_updated_on

      t.timestamps
    end

  end

  def self.down
    drop_table :im_indices
  end
end
