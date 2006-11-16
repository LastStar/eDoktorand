class AddPermissionsForAddingEnTitles < ActiveRecord::Migration
  def self.up
    Permission.create(:name => "study_plans/add_en")
    Permission.create(:name => "study_plans/save_en")
    Permission.create(:name => "disert_themes/add_en")
    Permission.create(:name => "disert_themes/save_en")
    Role.find_by_name("student").permissions << Permission.find_by_name('study_plans/add_en')
    Role.find_by_name("student").permissions << Permission.find_by_name('study_plans/save_en')
    Role.find_by_name("student").permissions << Permission.find_by_name('disert_themes/add_en')
    Role.find_by_name("student").permissions << Permission.find_by_name('disert_themes/save_en')
    Role.find_by_name("faculty_secretary").permissions << Permission.find_by_name('study_plans/add_en')
    Role.find_by_name("faculty_secretary").permissions << Permission.find_by_name('study_plans/save_en')
    Role.find_by_name("faculty_secretary").permissions << Permission.find_by_name('disert_themes/add_en')
    Role.find_by_name("faculty_secretary").permissions << Permission.find_by_name('disert_themes/save_en')
    Role.find_by_name("department_secretary").permissions << Permission.find_by_name('study_plans/add_en')
    Role.find_by_name("department_secretary").permissions << Permission.find_by_name('study_plans/save_en')
    Role.find_by_name("department_secretary").permissions << Permission.find_by_name('disert_themes/add_en')
    Role.find_by_name("department_secretary").permissions << Permission.find_by_name('disert_themes/save_en')
  end

  def self.down
    Permission.find_by_name("study_plans/add_en").destroy
    Permission.find_by_name("study_plans/save_en").destroy
    Permission.find_by_name("disert_themes/add_en").destroy
    Permission.find_by_name("disert_themes/save_en").destroy
  end
end
