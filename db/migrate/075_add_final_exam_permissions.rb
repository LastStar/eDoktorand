class AddFinalExamPermissions < ActiveRecord::Migration
  def self.up
    Role.find(2).permissions << 
      Permission.create(:name => 'final_exam_terms/send_invitation')
    Role.find(2).permissions << 
      Permission.find_by_name('final_exam_terms/show')

  end

  def self.down
    Role.find(2).permissions.delete
      Permission.find_by_name('final_exam_terms/send_invitation')
    Role.find(2).permissions.delete
      Permission.find_by_name('final_exam_terms/show')
  end
end
