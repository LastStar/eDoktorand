# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 144) do

  create_table "actualities", :force => true do |t|
    t.string "label"
    t.text   "content"
  end

  create_table "address_types", :force => true do |t|
    t.string "label", :limit => 20
  end

  create_table "addresses", :force => true do |t|
    t.string  "street",          :limit => 100
    t.string  "desc_number",     :limit => 20
    t.string  "orient_number",   :limit => 20
    t.string  "city",            :limit => 100
    t.string  "zip",             :limit => 20
    t.string  "state",           :limit => 100
    t.integer "address_type_id"
    t.integer "student_id"
  end

  create_table "approvements", :force => true do |t|
    t.string   "type",                :limit => 30
    t.integer  "document_id"
    t.integer  "tutor_statement_id"
    t.integer  "leader_statement_id"
    t.integer  "dean_statement_id"
    t.integer  "board_statement_id"
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  add_index "approvements", ["document_id"], :name => "index_approvements_on_document_id"

  create_table "atestation_details", :force => true do |t|
    t.text     "detail"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "study_plan_id"
    t.datetime "atestation_term"
  end

  create_table "candidates", :force => true do |t|
    t.string   "firstname",              :limit => 50
    t.string   "lastname",               :limit => 50
    t.integer  "title_before_id"
    t.integer  "title_after_id"
    t.integer  "coridor_id"
    t.date     "study_end"
    t.string   "university",             :limit => 100
    t.date     "birth_on"
    t.string   "birth_number",           :limit => 11
    t.string   "birth_at",               :limit => 100
    t.string   "email",                  :limit => 100
    t.string   "street",                 :limit => 100
    t.integer  "number"
    t.string   "city",                   :limit => 100
    t.string   "zip",                    :limit => 10
    t.string   "postal_street",          :limit => 100
    t.integer  "postal_number"
    t.string   "postal_city",            :limit => 100
    t.string   "postal_zip",             :limit => 10
    t.string   "phone",                  :limit => 50
    t.string   "state",                  :limit => 50
    t.string   "studied_branch",         :limit => 200
    t.string   "employer",               :limit => 50
    t.string   "employer_address",       :limit => 50
    t.string   "employer_email",         :limit => 50
    t.string   "employer_phone",         :limit => 50
    t.string   "position",               :limit => 50
    t.integer  "department_id"
    t.integer  "language1_id"
    t.integer  "language2_id"
    t.integer  "study_id"
    t.string   "faculty",                :limit => 100
    t.string   "studied_specialization", :limit => 100
    t.string   "study_theme",            :limit => 1000
    t.text     "note"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.datetime "finished_on"
    t.datetime "ready_on"
    t.datetime "admited_on"
    t.datetime "invited_on"
    t.datetime "rejected_on"
    t.datetime "enrolled_on"
    t.integer  "student_id"
    t.integer  "tutor_id"
    t.string   "address_state",          :limit => 240
    t.string   "postal_state",           :limit => 240
    t.string   "language"
    t.string   "sex"
  end

  create_table "contact_types", :force => true do |t|
    t.string "label", :limit => 20
  end

  create_table "contacts", :force => true do |t|
    t.string   "name",            :limit => 50
    t.integer  "contact_type_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coridor_subjects", :force => true do |t|
    t.integer "coridor_id"
    t.integer "subject_id"
    t.string  "type",         :limit => 32
    t.integer "requisite_on"
  end

  create_table "coridors", :force => true do |t|
    t.text    "name"
    t.text    "name_english"
    t.string  "code",             :limit => 16
    t.integer "faculty_id"
    t.integer "accredited",       :limit => 1
    t.integer "program_id"
    t.integer "voluntary_amount"
  end

  create_table "deanships", :force => true do |t|
    t.integer  "faculty_id"
    t.integer  "dean_id"
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "departments", :force => true do |t|
    t.text    "name"
    t.text    "name_english"
    t.string  "short_name",   :limit => 8
    t.integer "faculty_id"
  end

  create_table "departments_subjects", :id => false, :force => true do |t|
    t.integer "department_id"
    t.integer "subject_id"
  end

  create_table "diploma_supplements", :force => true do |t|
    t.integer  "diploma_no"
    t.string   "faculty_name_en"
    t.string   "family_name"
    t.string   "given_name"
    t.string   "date_of_birth"
    t.string   "study_programme"
    t.string   "study_specialization"
    t.string   "faculty_name"
    t.string   "study_mode"
    t.text     "plan_subjects"
    t.string   "disert_theme_title",   :limit => 512
    t.string   "defense_passed_on"
    t.text     "final_areas"
    t.string   "final_exam_passed_on"
    t.string   "faculty_www"
    t.string   "printed_on"
    t.string   "dean_display_name"
    t.string   "dean_title"
    t.datetime "printed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "disert_themes", :force => true do |t|
    t.string   "title",                :limit => 1023
    t.integer  "index_id"
    t.datetime "methodology_added_on"
    t.integer  "finishing_to"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.text     "methodology_summary"
    t.datetime "approved_on"
    t.string   "title_en",             :limit => 1023
    t.date     "defense_passed_on"
    t.integer  "actual"
    t.string   "literature_review",    :limit => 1023
  end

  add_index "disert_themes", ["index_id"], :name => "index_disert_themes_on_index_id"

  create_table "documents", :force => true do |t|
    t.string   "name",       :limit => 100
    t.string   "path",       :limit => 100
    t.integer  "faculty_id"
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "employments", :force => true do |t|
    t.integer  "unit_id"
    t.integer  "person_id"
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "exam_terms", :force => true do |t|
    t.integer  "coridor_id"
    t.date     "date"
    t.string   "start_time",         :limit => 5
    t.string   "room"
    t.integer  "chairman_id"
    t.string   "first_examinator",   :limit => 100
    t.string   "second_examinator",  :limit => 100
    t.string   "third_examinator",   :limit => 100
    t.string   "fourth_examinator",  :limit => 100
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "type"
    t.integer  "index_id"
    t.string   "fifth_examinator"
    t.string   "sixth_examinator"
    t.string   "opponent"
    t.string   "first_subject"
    t.string   "second_subject"
    t.string   "third_subject"
    t.string   "fourth_subject"
    t.string   "fifth_subject"
    t.string   "sixth_subject"
    t.string   "seventh_examinator"
    t.string   "eighth_examinator"
    t.string   "nineth_examinator"
    t.string   "second_opponent"
    t.string   "third_opponent"
  end

  create_table "exams", :force => true do |t|
    t.integer  "index_id"
    t.integer  "first_examinator_id"
    t.integer  "second_examinator_id"
    t.integer  "result"
    t.text     "questions"
    t.integer  "subject_id"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "passed_on"
    t.integer  "third_examinator_id"
    t.integer  "fourth_examinator_id"
  end

  create_table "external_subject_details", :force => true do |t|
    t.integer  "external_subject_id"
    t.text     "university"
    t.text     "person"
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "faculties", :force => true do |t|
    t.text    "name"
    t.text    "name_english"
    t.string  "short_name",     :limit => 8
    t.text    "ldap_context"
    t.string  "street"
    t.integer "stipendia_code"
    t.string  "www",            :limit => 100
  end

  create_table "indices", :force => true do |t|
    t.integer  "student_id"
    t.integer  "department_id"
    t.integer  "coridor_id"
    t.integer  "tutor_id"
    t.integer  "study_id"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.datetime "finished_on"
    t.integer  "created_by_id"
    t.integer  "update_by_id"
    t.integer  "payment_id"
    t.datetime "enrolled_on"
    t.datetime "interupted_on"
    t.string   "account_number_prefix"
    t.string   "account_number"
    t.string   "account_bank_number"
    t.datetime "final_application_claimed_at"
    t.datetime "approved_on"
    t.datetime "canceled_on"
    t.datetime "final_exam_invitation_sent_at"
    t.string   "consultant"
    t.date     "final_exam_passed_on"
    t.datetime "defense_claimed_at"
    t.datetime "defense_invitation_sent_at"
  end

  add_index "indices", ["student_id"], :name => "indices_student_id_index"
  add_index "indices", ["department_id"], :name => "indices_department_id_index"
  add_index "indices", ["coridor_id"], :name => "indices_coridor_id_index"
  add_index "indices", ["tutor_id"], :name => "indices_tutor_id_index"
  add_index "indices", ["finished_on"], :name => "indices_finished_on_index"
  add_index "indices", ["enrolled_on"], :name => "indices_enrolled_on_index"

  create_table "interupts", :force => true do |t|
    t.integer  "index_id"
    t.string   "note",         :limit => 512
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "duration",     :limit => 1
    t.integer  "plan_changed", :limit => 1
    t.datetime "start_on"
    t.datetime "approved_on"
    t.datetime "canceled_on"
    t.datetime "ended_on"
    t.datetime "finished_on"
  end

  add_index "interupts", ["index_id"], :name => "index_interupts_on_index_id"

  create_table "leaderships", :force => true do |t|
    t.integer  "department_id"
    t.integer  "leader_id"
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "parameters", :force => true do |t|
    t.integer "faculty_id"
    t.string  "name",       :limit => 240
    t.text    "value"
  end

  create_table "people", :force => true do |t|
    t.string   "firstname",                 :limit => 101
    t.string   "lastname",                  :limit => 100
    t.date     "birth_on"
    t.string   "birth_number",              :limit => 10
    t.string   "state",                     :limit => 100
    t.string   "type",                      :limit => 20
    t.integer  "title_before_id"
    t.integer  "title_after_id"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "uic"
    t.string   "birthname",                 :limit => 100
    t.string   "citizenship"
    t.datetime "scholarship_claimed_at"
    t.datetime "scholarship_supervised_at"
    t.string   "birth_place"
    t.string   "language"
    t.string   "sex"
    t.integer  "sident"
  end

  add_index "people", ["lastname"], :name => "people_lastname_index"
  add_index "people", ["type"], :name => "type_idx"

  create_table "permissions", :force => true do |t|
    t.string   "name",       :limit => 100
    t.string   "info",       :limit => 100
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "permissions_roles", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "permission_id"
  end

  create_table "plan_subjects", :force => true do |t|
    t.integer  "study_plan_id"
    t.integer  "subject_id"
    t.integer  "finishing_on"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.datetime "finished_on"
  end

  add_index "plan_subjects", ["study_plan_id"], :name => "index_plan_subjects_on_study_plan_id"
  add_index "plan_subjects", ["subject_id"], :name => "index_plan_subjects_on_subject_id"

  create_table "probation_terms", :force => true do |t|
    t.integer  "subject_id"
    t.integer  "first_examinator_id"
    t.integer  "second_examinator_id"
    t.date     "date"
    t.string   "start_time",           :limit => 5
    t.string   "room",                 :limit => 20
    t.integer  "max_students"
    t.text     "note"
    t.integer  "created_by"
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "probation_terms_students", :id => false, :force => true do |t|
    t.integer "probation_term_id"
    t.integer "student_id"
  end

  create_table "programs", :force => true do |t|
    t.string "label"
    t.string "label_en"
  end

  create_table "roles", :force => true do |t|
    t.string   "name",       :limit => 20
    t.string   "info",       :limit => 100
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  create_table "scholarships", :force => true do |t|
    t.string   "label"
    t.text     "content"
    t.integer  "index_id"
    t.float    "amount",          :default => 0.0
    t.string   "commission_head"
    t.string   "commission_body"
    t.string   "commission_tail"
    t.datetime "payed_on"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.string   "type"
    t.datetime "approved_on"
  end

  add_index "scholarships", ["index_id"], :name => "index_scholarships_on_index_id"

  create_table "sessions", :force => true do |t|
    t.text "sessid"
    t.text "data"
  end

  create_table "statements", :force => true do |t|
    t.string   "note",       :limit => 1023
    t.integer  "result"
    t.integer  "person_id"
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "studies", :force => true do |t|
    t.string "name",    :limit => 50
    t.string "name_en"
  end

  create_table "study_plans", :force => true do |t|
    t.integer  "index_id"
    t.integer  "actual"
    t.integer  "finishing_to"
    t.datetime "admited_on"
    t.datetime "canceled_on"
    t.datetime "approved_on"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.datetime "last_atested_on"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.text     "final_areas"
    t.datetime "final_exam_admited_at"
  end

  add_index "study_plans", ["admited_on"], :name => "admited_on"
  add_index "study_plans", ["canceled_on"], :name => "canceled_on"
  add_index "study_plans", ["approved_on"], :name => "approved_on"
  add_index "study_plans", ["actual"], :name => "actual_idx"
  add_index "study_plans", ["index_id"], :name => "index_study_plans_on_index_id"

  create_table "subjects", :force => true do |t|
    t.text     "label"
    t.string   "code",       :limit => 7
    t.string   "type",       :limit => 32
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "label_en"
  end

  add_index "subjects", ["code"], :name => "code"

  create_table "titles", :force => true do |t|
    t.string  "label",  :limit => 100
    t.integer "prefix"
  end

  create_table "tutorships", :force => true do |t|
    t.integer  "tutor_id"
    t.integer  "coridor_id"
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  add_index "tutorships", ["coridor_id"], :name => "coridor_idx"
  add_index "tutorships", ["tutor_id"], :name => "tutor_idx"

  create_table "users", :force => true do |t|
    t.string   "login",      :limit => 80
    t.integer  "person_id"
    t.datetime "created_on"
    t.datetime "updated_on"
  end

end
