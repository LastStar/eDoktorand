class ChangePermissionName < ActiveRecord::Migration
  def self.up
    Permission.find_by_name('probation_terms/enroll_student_term').\
      update_attribute(:name, 'probation_terms/enroll_student')
  end

  def self.down
    Permission.find_by_name('probation_terms/enroll_student').\
      update_attribute(:name, 'probation_terms/enroll_student_term')
  end
end
