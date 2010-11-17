class AddAnnualReportPermissions < ActiveRecord::Migration
  def self.up
    permission = Permission.create(:name => 'study_plans/annual_report')
    ['faculty_secretary','department_secretary',  'tutor', 'leader', 'dean'].each do |role|
      Role.find_by_name(role).permissions << permission
    end
  end

  def self.down
    permissioon = Permission.find_by_name('study_plans/annual_report')
    ['faculty_secretary', 'department_secretary', 'tutor', 'leader', 'dean', 'student'].each do |role|
      Role.find_by_name(role).permissions.delete(permission)
    end
  end
end
