class FinalExamPermissionsForStudent < ActiveRecord::Migration
  def self.up
    Role.find(3).permissions <<
      Permission.create(:name => 'final_exam_terms/show')
  end

  def self.down
    per = Permission.find_by_name('final_exam_terms/show')
    Role.find(3).permissions.delete per
    per.destroy
  end
end
