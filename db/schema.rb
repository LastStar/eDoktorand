# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 91) do

  create_table "actualities", :force => true do |t|
    t.column "label", :string
    t.column "content", :text
  end

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
    t.column "created_on", :datetime
    t.column "updated_on", :datetime
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
    t.column "language1_id", :integer
    t.column "language2_id", :integer
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
    t.column "address_state", :string, :limit => 240
    t.column "postal_state", :string, :limit => 240
    t.column "language", :string
    t.column "sex", :string
  end

  create_table "contact_types", :force => true do |t|
    t.column "label", :string, :limit => 20
  end

  create_table "contacts", :force => true do |t|
    t.column "name", :string, :limit => 50
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
    t.column "accredited", :integer, :limit => 1
  end

  create_table "deanships", :force => true do |t|
    t.column "faculty_id", :integer
    t.column "dean_id", :integer
    t.column "created_on", :datetime
    t.column "updated_on", :datetime
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
    t.column "title_en", :string
    t.column "defense_passed_on", :date
  end

  create_table "documents", :force => true do |t|
    t.column "name", :string, :limit => 100
    t.column "path", :string, :limit => 100
    t.column "faculty_id", :integer
    t.column "created_on", :datetime
    t.column "updated_on", :datetime
  end

  create_table "employments", :force => true do |t|
    t.column "unit_id", :integer
    t.column "person_id", :integer
    t.column "created_on", :datetime
    t.column "updated_on", :datetime
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
    t.column "created_on", :datetime
    t.column "updated_on", :datetime
    t.column "type", :string
    t.column "index_id", :integer
    t.column "fifth_examinator", :string
    t.column "sixth_examinator", :string
    t.column "opponent", :string
    t.column "first_subject", :string
    t.column "second_subject", :string
    t.column "third_subject", :string
    t.column "fourth_subject", :string
    t.column "fifth_subject", :string
    t.column "sixth_subject", :string
  end

  create_table "exams", :force => true do |t|
    t.column "index_id", :integer
    t.column "first_examinator_id", :integer
    t.column "second_examinator_id", :integer
    t.column "result", :integer
    t.column "questions", :text
    t.column "subject_id", :integer
    t.column "created_on", :datetime
    t.column "updated_on", :datetime
    t.column "created_by_id", :integer
    t.column "updated_by_id", :integer
  end

  create_table "external_subject_details", :force => true do |t|
    t.column "external_subject_id", :integer
    t.column "university", :text
    t.column "person", :text
    t.column "created_on", :datetime
    t.column "updated_on", :datetime
  end

  create_table "faculties", :force => true do |t|
    t.column "name", :text
    t.column "name_english", :text
    t.column "short_name", :string, :limit => 8
    t.column "ldap_context", :text
    t.column "street", :string
    t.column "stipendia_code", :integer
  end

  create_table "indices", :force => true do |t|
    t.column "student_id", :integer
    t.column "department_id", :integer
    t.column "coridor_id", :integer
    t.column "tutor_id", :integer
    t.column "study_id", :integer
    t.column "created_on", :datetime
    t.column "updated_on", :datetime
    t.column "finished_on", :datetime
    t.column "created_by_id", :integer
    t.column "update_by_id", :integer
    t.column "payment_id", :integer
    t.column "enrolled_on", :datetime
    t.column "interupted_on", :datetime
    t.column "account_number_prefix", :string
    t.column "account_number", :string
    t.column "account_bank_number", :string
    t.column "final_application_claimed_at", :datetime
    t.column "approved_on", :datetime
    t.column "canceled_on", :datetime
    t.column "final_exam_invitation_sent_at", :datetime
    t.column "consultant", :string
    t.column "final_exam_passed_on", :date
  end

  add_index "indices", ["student_id"], :name => "indices_student_id_index"
  add_index "indices", ["department_id"], :name => "indices_department_id_index"
  add_index "indices", ["coridor_id"], :name => "indices_coridor_id_index"
  add_index "indices", ["tutor_id"], :name => "indices_tutor_id_index"
  add_index "indices", ["finished_on"], :name => "indices_finished_on_index"
  add_index "indices", ["enrolled_on"], :name => "indices_enrolled_on_index"

  create_table "interupts", :force => true do |t|
    t.column "index_id", :integer
    t.column "note", :string, :limit => 100
    t.column "created_on", :datetime
    t.column "updated_on", :datetime
    t.column "duration", :integer, :limit => 1
    t.column "plan_changed", :integer, :limit => 1
    t.column "start_on", :datetime
    t.column "approved_on", :datetime
    t.column "canceled_on", :datetime
    t.column "ended_on", :datetime
    t.column "finished_on", :datetime
  end

  create_table "leaderships", :force => true do |t|
    t.column "department_id", :integer
    t.column "leader_id", :integer
    t.column "created_on", :datetime
    t.column "updated_on", :datetime
  end

  create_table "parameters", :force => true do |t|
    t.column "faculty_id", :integer
    t.column "name", :string, :limit => 240
    t.column "value", :text
  end

  create_table "people", :force => true do |t|
    t.column "firstname", :string, :limit => 101
    t.column "lastname", :string, :limit => 100
    t.column "birth_on", :date
    t.column "birth_number", :string, :limit => 10
    t.column "state", :string, :limit => 100
    t.column "type", :string, :limit => 20
    t.column "title_before_id", :integer
    t.column "title_after_id", :integer
    t.column "created_on", :datetime
    t.column "updated_on", :datetime
    t.column "uic", :integer
    t.column "birthname", :string, :limit => 100
    t.column "citizenship", :string
    t.column "scholarship_claimed_at", :datetime
    t.column "scholarship_supervised_at", :datetime
    t.column "birth_place", :string
    t.column "language", :string
    t.column "sex", :string
    t.column "sident", :integer
  end

  add_index "people", ["lastname"], :name => "people_lastname_index"

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
    t.column "created_on", :datetime
    t.column "updated_on", :datetime
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
    t.column "created_on", :datetime
    t.column "updated_on", :datetime
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.column "user_id", :integer
    t.column "role_id", :integer
  end

  create_table "scholarships", :force => true do |t|
    t.column "label", :string
    t.column "content", :text
    t.column "index_id", :integer
    t.column "amount", :float
    t.column "commission_head", :integer
    t.column "commission_body", :integer
    t.column "commission_tail", :integer
    t.column "payed_on", :datetime
    t.column "created_on", :datetime
    t.column "updated_on", :datetime
    t.column "created_by_id", :integer
    t.column "update_by_id", :integer
    t.column "type", :string
    t.column "approved_on", :datetime
  end

  create_table "sessions", :force => true do |t|
    t.column "sessid", :text
    t.column "data", :text
  end

  create_table "statements", :force => true do |t|
    t.column "note", :string, :limit => 100
    t.column "result", :integer
    t.column "person_id", :integer
    t.column "created_on", :datetime
    t.column "updated_on", :datetime
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
    t.column "final_exam_admited_at", :datetime
  end

  add_index "study_plans", ["admited_on"], :name => "admited_on"
  add_index "study_plans", ["canceled_on"], :name => "canceled_on"
  add_index "study_plans", ["approved_on"], :name => "approved_on"

  create_table "subjects", :force => true do |t|
    t.column "label", :text
    t.column "code", :string, :limit => 7
    t.column "type", :string, :limit => 32
    t.column "created_on", :datetime
    t.column "updated_on", :datetime
  end

  add_index "subjects", ["code"], :name => "code"

  create_table "titles", :force => true do |t|
    t.column "label", :string, :limit => 100
    t.column "prefix", :integer
  end

  create_table "tutorships", :force => true do |t|
    t.column "department_id", :integer
    t.column "tutor_id", :integer
    t.column "coridor_id", :integer
    t.column "created_on", :datetime
    t.column "updated_on", :datetime
  end

  create_table "users", :force => true do |t|
    t.column "login", :string, :limit => 80
    t.column "password", :string, :limit => 40
    t.column "person_id", :integer
    t.column "created_on", :datetime
    t.column "updated_on", :datetime
  end

end
