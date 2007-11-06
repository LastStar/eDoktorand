class AddPermissionToClaimFinalExam < ActiveRecord::Migration
  def self.up
    Role.find(3).permissions <<
      Permission.create('name' => 'final_exam_terms/claim')
    Role.find(3).permissions <<
      Permission.create('name' => 'final_exam_terms/confirm_claim')
  end

  def self.down
    permission = Permission.find_by_name('final_exam_terms/claim')
    Role.find(3).persmissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('final_exam_terms/confirm_claim')
    Role.find(3).persmissions.delete(permission)
    permission.destroy
  end
end
