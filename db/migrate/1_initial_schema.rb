class InitialSchema < ActiveRecord::Migration
  def self.up

    create_table "address_types", :force => true do |t|
      t.column "label", :string, :limit => 20
    end

    create_table "addresses", :force => true do |t|
      t.column "street", :string, :limit => 100
      t.column "desc_number", :string, :limit => 20
      t.column "orient_number", :string, :limit => 20
      t.column "city", :string, :limit => 20
      t.column "zip", :string, :limit => 20
      t.column "state", :string, :limit => 20
      t.column "address_type_id", :integer
      t.column "student_id", :integer
    end

    create_table "approvements", :force => true do |t|
      t.column "type", :string, :limit => 30
      t.column "document_id", :integer
      t.column "tutor_statement_id", :integer
      t.column "leader_statement_id", :integer
      t.column "dean_statement_id", :integer
      t.column "board_statement_id", :integer
      t.column "created_on", :timestamp
      t.column "updated_on", :timestamp
    end

    create_table "atestation_details", :force => true do |t|
      t.column "detail", :text
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
      t.column "study_plan_id", :integer
      t.column "atestation_term", :datetime
    end

    create_table "candidates", :force => true do |t|
      t.column "firstname", :string, :limit => 50
      t.column "lastname", :string, :limit => 50
      t.column "title_before_id", :integer
      t.column "title_after_id", :integer
      t.column "coridor_id", :integer
      t.column "study_end", :date
      t.column "university", :string, :limit => 100
      t.column "birth_on", :date
      t.column "birth_number", :string, :limit => 11
      t.column "birth_at", :string, :limit => 100
      t.column "email", :string, :limit => 100
      t.column "street", :string, :limit => 100
      t.column "number", :integer
      t.column "city", :string, :limit => 100
      t.column "zip", :string, :limit => 10
      t.column "postal_street", :string, :limit => 100
      t.column "postal_number", :integer
      t.column "postal_city", :string, :limit => 100
      t.column "postal_zip", :string, :limit => 10
      t.column "phone", :string, :limit => 50
      t.column "state", :string, :limit => 50
      t.column "studied_branch", :string, :limit => 200
      t.column "employer", :string, :limit => 50
      t.column "employer_address", :string, :limit => 50
      t.column "employer_email", :string, :limit => 50
      t.column "employer_phone", :string, :limit => 50
      t.column "position", :string, :limit => 50
      t.column "department_id", :integer
      t.column "language1", :integer
      t.column "language2", :integer
      t.column "study_id", :integer
      t.column "faculty", :string, :limit => 100
      t.column "studied_specialization", :string, :limit => 100
      t.column "study_theme", :string, :limit => 100
      t.column "note", :text
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
      t.column "finished_on", :datetime
      t.column "ready_on", :datetime
      t.column "admited_on", :datetime
      t.column "invited_on", :datetime
      t.column "rejected_on", :datetime
      t.column "enrolled_on", :datetime
      t.column "student_id", :integer
      t.column "tutor_id", :integer
    end

    create_table "contact_types", :force => true do |t|
      t.column "label", :string, :limit => 20
    end

    create_table "contacts", :force => true do |t|
      t.column "name", :string, :limit => 20
      t.column "contact_type_id", :integer
      t.column "person_id", :integer
    end

    create_table "coridor_subjects", :force => true do |t|
      t.column "coridor_id", :integer
      t.column "subject_id", :integer
      t.column "type", :string, :limit => 32
      t.column "requisite_on", :integer
    end

    create_table "coridors", :force => true do |t|
      t.column "name", :text
      t.column "name_english", :text
      t.column "code", :string, :limit => 16
      t.column "faculty_id", :integer
    end

    create_table "deanships", :force => true do |t|
      t.column "faculty_id", :integer
      t.column "dean_id", :integer
      t.column "created_on", :timestamp
      t.column "updated_on", :timestamp
    end

    create_table "departments", :force => true do |t|
      t.column "name", :text
      t.column "name_english", :text
      t.column "short_name", :string, :limit => 8
      t.column "faculty_id", :integer
    end

    create_table "departments_subjects", :id => false, :force => true do |t|
      t.column "department_id", :integer
      t.column "subject_id", :integer
    end

    create_table "disert_themes", :force => true do |t|
      t.column "title", :string, :limit => 100
      t.column "index_id", :integer
      t.column "methodology_added_on", :datetime
      t.column "finishing_to", :integer
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
      t.column "methodology_summary", :text
      t.column "approved_on", :datetime
    end

    create_table "documents", :force => true do |t|
      t.column "name", :string, :limit => 100
      t.column "path", :string, :limit => 100
      t.column "faculty_id", :integer
      t.column "created_on", :timestamp
      t.column "updated_on", :timestamp
    end

    create_table "employments", :force => true do |t|
      t.column "unit_id", :integer
      t.column "person_id", :integer
      t.column "created_on", :timestamp
      t.column "updated_on", :timestamp
    end

    create_table "exam_terms", :force => true do |t|
      t.column "coridor_id", :integer
      t.column "date", :date
      t.column "start_time", :string, :limit => 5
      t.column "room", :string, :limit => 20
      t.column "chairman_id", :integer
      t.column "first_examinator", :string, :limit => 100
      t.column "second_examinator", :string, :limit => 100
      t.column "third_examinator", :string, :limit => 100
      t.column "fourth_examinator", :string, :limit => 100
      t.column "created_on", :timestamp
      t.column "updated_on", :timestamp
    end

    create_table "exams", :force => true do |t|
      t.column "index_id", :integer
      t.column "first_examinator_id", :integer
      t.column "second_examinator_id", :integer
      t.column "result", :integer
      t.column "questions", :text
      t.column "subject_id", :integer
      t.column "created_on", :timestamp
      t.column "updated_on", :timestamp
      t.column "created_by_id", :integer
      t.column "updated_by_id", :integer
    end

    create_table "external_subject_details", :force => true do |t|
      t.column "external_subject_id", :integer
      t.column "university", :text
      t.column "person", :text
      t.column "created_on", :timestamp
      t.column "updated_on", :timestamp
    end

    create_table "faculties", :force => true do |t|
      t.column "name", :text
      t.column "name_english", :text
      t.column "short_name", :string, :limit => 8
      t.column "ldap_context", :text
    end

    create_table "indices", :force => true do |t|
      t.column "student_id", :integer
      t.column "department_id", :integer
      t.column "coridor_id", :integer
      t.column "tutor_id", :integer
      t.column "study_id", :integer
      t.column "created_on", :timestamp
      t.column "updated_on", :timestamp
      t.column "finished_on", :timestamp
      t.column "created_by_id", :integer
      t.column "update_by_id", :integer
      t.column "payment_id", :integer
      t.column "enrolled_on", :timestamp
      t.column "interupted_on", :timestamp
    end

    create_table "interupts", :force => true do |t|
      t.column "index_id", :integer
      t.column "note", :string, :limit => 100
      t.column "created_on", :timestamp
      t.column "updated_on", :timestamp
    end

    create_table "languages", :force => true do |t|
      t.column "name", :string, :limit => 50
    end

    create_table "leaderships", :force => true do |t|
      t.column "department_id", :integer
      t.column "leader_id", :integer
      t.column "created_on", :timestamp
      t.column "updated_on", :timestamp
    end

    create_table "people", :force => true do |t|
      t.column "firstname", :string, :limit => 101
      t.column "lastname", :string, :limit => 100
      t.column "birth_on", :date
      t.column "birth_number", :string, :limit => 10
      t.column "state", :string, :limit => 100
      t.column "birth_at", :string, :limit => 100
      t.column "type", :string, :limit => 20
      t.column "title_before_id", :integer
      t.column "title_after_id", :integer
      t.column "created_on", :timestamp
      t.column "updated_on", :timestamp
      t.column "uic", :integer
      t.column "birthname", :string, :limit => 100
    end

    create_table "permissions", :force => true do |t|
      t.column "name", :string, :limit => 100
      t.column "info", :string, :limit => 100
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
    end

    create_table "permissions_roles", :id => false, :force => true do |t|
      t.column "role_id", :integer
      t.column "permission_id", :integer
    end

    create_table "plan_subjects", :force => true do |t|
      t.column "study_plan_id", :integer
      t.column "subject_id", :integer
      t.column "finishing_on", :integer
      t.column "created_on", :timestamp
      t.column "updated_on", :timestamp
      t.column "finished_on", :datetime
    end

    create_table "probation_terms", :force => true do |t|
      t.column "subject_id", :integer
      t.column "first_examinator_id", :integer
      t.column "second_examinator_id", :integer
      t.column "date", :date
      t.column "start_time", :string, :limit => 5
      t.column "room", :string, :limit => 20
      t.column "max_students", :integer
      t.column "note", :text
      t.column "created_by", :integer
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
    end

    create_table "probation_terms_students", :id => false, :force => true do |t|
      t.column "probation_term_id", :integer
      t.column "student_id", :integer
    end

    create_table "roles", :force => true do |t|
      t.column "name", :string, :limit => 20
      t.column "info", :string, :limit => 100
      t.column "created_on", :timestamp
      t.column "updated_on", :timestamp
    end

    create_table "roles_users", :id => false, :force => true do |t|
      t.column "user_id", :integer
      t.column "role_id", :integer
    end

    create_table "sessions", :force => true do |t|
      t.column "sessid", :text
      t.column "data", :text
    end

    create_table "statements", :force => true do |t|
      t.column "note", :string, :limit => 100
      t.column "result", :integer
      t.column "person_id", :integer
      t.column "created_on", :timestamp
      t.column "updated_on", :timestamp
    end

    create_table "studies", :force => true do |t|
      t.column "name", :string, :limit => 50
    end

    create_table "study_plans", :force => true do |t|
      t.column "index_id", :integer
      t.column "actual", :integer
      t.column "finishing_to", :integer
      t.column "admited_on", :datetime
      t.column "canceled_on", :datetime
      t.column "approved_on", :datetime
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
      t.column "last_atested_on", :datetime
      t.column "created_by_id", :integer
      t.column "updated_by_id", :integer
      t.column "final_areas", :text
    end

    create_table "subjects", :force => true do |t|
      t.column "label", :text
      t.column "code", :string, :limit => 7
      t.column "type", :string, :limit => 32
      t.column "created_on", :timestamp
      t.column "updated_on", :timestamp
    end

    create_table "titles", :force => true do |t|
      t.column "label", :string, :limit => 100
      t.column "prefix", :integer
    end

    create_table "tutorships", :force => true do |t|
      t.column "department_id", :integer
      t.column "tutor_id", :integer
      t.column "coridor_id", :integer
      t.column "created_on", :timestamp
      t.column "updated_on", :timestamp
    end

    create_table "users", :force => true do |t|
      t.column "login", :string, :limit => 80
      t.column "password", :string, :limit => 40
      t.column "person_id", :integer
      t.column "created_on", :timestamp
      t.column "updated_on", :timestamp
    end

    add_index "study_plans", ["admited_on"], :name => "admited_on"
    add_index "study_plans", ["canceled_on"], :name => "canceled_on"
    add_index "study_plans", ["approved_on"], :name => "approved_on"
    add_index "subjects", ["code"], :name => "code"

    Role.create('name' => 'admin')
    Role.create('name' => 'faculty_secretary')
    Role.create('name' => 'student')
    Role.create('name' => 'tutor')
    Role.create('name' => 'dean')
    Role.create('name' => 'leader')
    Role.create('name' => 'department_secretary')
    Role.create('name' => 'vicerector')

  end

  def self.down


    drop_table "address_types"

    drop_table "addresses"

    drop_table "approvements"

    drop_table "atestation_details"

    drop_table "candidates"

    drop_table "contact_types"

    drop_table "contacts"

    drop_table "coridor_subjects"

    drop_table "coridors"

    drop_table "deanships"

    drop_table "departments"

    drop_table "departments_subjects"

    drop_table "disert_themes"

    drop_table "documents"

    drop_table "employments"

    drop_table "exam_terms"

    drop_table "exams"

    drop_table "external_subject_details"

    drop_table "faculties"

    drop_table "indices"

    drop_table "interupts"

    drop_table "languages"

    drop_table "leaderships"

    drop_table "people"

    drop_table "permissions"

    drop_table "permissions_roles"

    drop_table "plan_subjects"

    drop_table "probation_terms"

    drop_table "probation_terms_students"

    drop_table "roles"

    drop_table "roles_users"

    drop_table "sessions"

    drop_table "statements"

    drop_table "studies"

    drop_table "study_plans"

    drop_table "subjects"

    drop_table "titles"

    drop_table "tutorships"

    drop_table "users"

  end
end
