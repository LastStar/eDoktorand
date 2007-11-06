class AddPermissionToFinalExamTerms < ActiveRecord::Migration
  def self.up
    Role.find(2).permissions <<
      Permission.create('name' => 'final_exam_terms/list')
    Role.find(2).permissions <<
      Permission.create('name' => 'final_exam_terms/prepare_print')
    Role.find(2).permissions <<
      Permission.create('name' => 'final_exam_terms/protocol')
  end

  def self.down
    permission = Permission.find_by_name('final_exam_terms/list')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('final_exam_terms/prepare_print')
    Role.find(2).permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('final_exam_terms/protocol')
    Role.find(2).permissions.delete(permission)
    permission.destroy
  end
end
