class AddUniversitySecretary < ActiveRecord::Migration
  def self.up
    role = Role.create(:name => 'university_secretary')
    ["account/welcome", "account/logout", "students/index", "students/show",
    "students/list", "students/search", "students/filter",
    "students/multiple_filter", "actualities/show", "actualities/new",
    "actualities/edit", "actualities/list", "actualities/index",
    "actualities/create", "actualities/update", "actualities/destroy",
    "candidates/index", "candidates/by", "candidates/list",
    "candidates/list_all", "candidates/show", "candidates/summary",
    "candidates/list_admission_ready", "exam_terms/index",
    "exam_terms/list", "exam_terms/show", "exams/index", "exams/by_subject",
    "exams/detail", "exams/search", "exams/list", "final_exam_terms/show",
    "final_exam_terms/list", "final_exam_terms/protocol",
    "defenses/list", "defenses/announcement", "defenses/protocol",
    "defenses/show", "examinators/index", "examinators/list",
    "tutors/index", "tutors/list", "specializations/index",
    "specializations/attestation", "specializations/list",
    "specializations/subjects"].each do |action|
      puts action
      role.permissions << Permission.find_by_name(action)
    end
  end

  def self.down
    Role.first(:name => 'university_secretary').destroy
  end
end
