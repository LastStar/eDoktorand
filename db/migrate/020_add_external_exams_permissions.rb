class AddExternalExamsPermissions < ActiveRecord::Migration
  def self.up
    Role.find(7).permissions << Permission.create('name' => 
      'exams/external_exam')
    Role.find(7).permissions << Permission.create('name' => 
      'exams/save_external_exam_student')
    Role.find(7).permissions << Permission.create('name' => 
      'exams/save_external_exam_subject')
    Role.find(7).permissions << Permission.create('name' => 
      'exams/save_external')
    Role.find(2).permissions << Permission.create('name' => 
      'exams/external_exam')
    Role.find(2).permissions << Permission.create('name' => 
      'exams/save_external_exam_student')
    Role.find(2).permissions << Permission.create('name' => 
      'exams/save_external_exam_subject')
    Role.find(2).permissions << Permission.create('name' => 
      'exams/save_external')
  end

  def self.down
    permission = Permission.find_by_name('exams/external_exam')
    Role.find(7).permissions.delete(permission)
    Role.find(2).permissions.delete(permission)
    permission = Permission.find_by_name('exams/save_external_exam_student')
    Role.find(7).permissions.delete(permission)
    Role.find(2).permissions.delete(permission)
    permission = Permission.find_by_name('exams/save_external_exam_subject')
    Role.find(7).permissions.delete(permission)
    Role.find(2).permissions.delete(permission)
    permission = Permission.find_by_name('exams/save_external')
    Role.find(7).permissions.delete(permission)
    Role.find(2).permissions.delete(permission)
  end
end
