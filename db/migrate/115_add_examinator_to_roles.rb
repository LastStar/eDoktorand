class AddExaminatorToRoles < ActiveRecord::Migration
  def self.up
    Role.create(:name => "examinator")
    Role.find_by_name("examinator").permissions << Permission.find_by_name('account/welcome')
    Role.find_by_name("examinator").permissions << Permission.find_by_name('account/logout')
    Role.find_by_name("examinator").permissions << Permission.find_by_name('exams/index')
    Role.find_by_name("examinator").permissions << Permission.find_by_name('exams/create')
    Role.find_by_name("examinator").permissions << Permission.find_by_name('exams/by_subject')
    Role.find_by_name("examinator").permissions << Permission.find_by_name('exams/detail')
    Role.find_by_name("examinator").permissions << Permission.find_by_name('exams/save_subject')
    Role.find_by_name("examinator").permissions << Permission.find_by_name('exams/save_student_subject')
    Role.find_by_name("examinator").permissions << Permission.find_by_name('exams/save')
    Role.find_by_name("examinator").permissions << Permission.find_by_name('exams/save_student')
    Role.find_by_name("examinator").permissions << Permission.find_by_name('exams/external')
    Role.find_by_name("examinator").permissions << Permission.find_by_name('exams/save_external_student')
    Role.find_by_name("examinator").permissions << Permission.find_by_name('exams/save_external_subject')
    Role.find_by_name("examinator").permissions << Permission.find_by_name('exams/save_external')
  end

  def self.down
    Role.find_by_name("examinator").destroy
  end
end
