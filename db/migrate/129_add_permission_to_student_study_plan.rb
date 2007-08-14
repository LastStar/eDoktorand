class AddPermissionToStudentStudyPlan < ActiveRecord::Migration
  def self.up
    Role.find_by_name("student").permissions << Permission.create(:name => 'study_plans/edit_create')
    Role.find_by_name("student").permissions << Permission.create(:name => 'study_plans/edit_create_voluntary')
    Role.find_by_name("student").permissions << Permission.create(:name => 'study_plans/edit_create_language')
    Role.find_by_name("student").permissions << Permission.create(:name => 'study_plans/edit_create_disert')

  end

  def self.down
Role.find_by_name("student").permissions.delete(Permission.find_by_name('study_plans/edit_create'))
Role.find_by_name("student").permissions.delete(Permission.find_by_name('study_plans/edit_create_voluntary'))
Role.find_by_name("student").permissions.delete(Permission.find_by_name('study_plans/edit_create_language'))
Role.find_by_name("student").permissions.delete(Permission.find_by_name('study_plans/edit_create_disert'))
  end
end
