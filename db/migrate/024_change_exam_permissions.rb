class ChangeExamPermissions < ActiveRecord::Migration
  def self.up
    Permission.find_by_name('exams/exam_by_subject').update_attribute('name',\
      'exams/by_subject')
    Permission.find_by_name('exams/external_exam').update_attribute('name',\
      'exams/external')
    Permission.find_by_name('exams/save_external_exam_student').update_attribute('name',\
      'exams/save_external_student')
    Permission.find_by_name('exams/save_external_exam_subject').update_attribute('name',\
      'exams/save_external_subject')
    Permission.find_by_name('exams/save_exam_subject').update_attribute('name',\
      'exams/save_subject')
    Permission.find_by_name('exams/save_exam_student_subject').update_attribute('name',\
      'exams/save_student_subject')
    Permission.find_by_name('exams/save_exam_student').update_attribute('name',\
      'exams/save_student')
  end

  def self.down
    Permission.find_by_name('exams/by_subject').update_attribute('name',\
      'exams/exam_by_subject')
    Permission.find_by_name('exams/external').update_attribute('name',\
      'exams/external_exam')
    Permission.find_by_name('exams/save_external_student').update_attribute('name',\
      'exams/save_external_exam_student')
    Permission.find_by_name('exams/save_external_subject').update_attribute('name',\
      'exams/save_external_exam_subject')
    Permission.find_by_name('exams/save_subject').update_attribute('name',\
      'exams/save_exam_subject')
    Permission.find_by_name('exams/save_student_subject').update_attribute('name',\
      'exams/save_exam_student_subject')
    Permission.find_by_name('exams/save_student').update_attribute('name',\
      'exams/save_exam_student')
  end
end
