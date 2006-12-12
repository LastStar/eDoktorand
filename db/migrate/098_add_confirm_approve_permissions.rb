class AddConfirmApprovePermissions < ActiveRecord::Migration
  def self.up
    Role.find_by_name("faculty_secretary").permissions <<
      Permission.find_by_name('study_plans/confirm_approve')
    Role.find_by_name("faculty_secretary").permissions <<
      Permission.find_by_name('study_plans/confirm_atest')
    Role.find_by_name("faculty_secretary").permissions <<
      Permission.find_by_name('disert_themes/confirm_approve')
    Role.find_by_name("faculty_secretary").permissions <<
      Permission.find_by_name('interupts/confirm_approve')
    Role.find_by_name("faculty_secretary").permissions <<
      Permission.find_by_name('students/confirm_approve')
  end

  def self.down
    Role.find_by_name("faculty_secretary").permissions.delete
      Permission.find_by_name('study_plans/confirm_approve')
    Role.find_by_name("faculty_secretary").permissions.delete
      Permission.find_by_name('study_plans/confirm_atest')
    Role.find_by_name("faculty_secretary").permissions.delete
      Permission.find_by_name('disert_themes/confirm_approve')
    Role.find_by_name("faculty_secretary").permissions.delete
      Permission.find_by_name('interupts/confirm_approve')
    Role.find_by_name("faculty_secretary").permissions.delete
      Permission.find_by_name('students/confirm_approve')
  end
end
