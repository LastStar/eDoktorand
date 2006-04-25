class AddPermissionsForFinalExamTerms < ActiveRecord::Migration
  def self.up
   p = Permission.create(:name => 'final_exam_terms/new')
   Role.find(2).permissions << p
   p = Permission.create(:name => 'final_exam_terms/create')
   Role.find(2).permissions << p
   p = Permission.create(:name => 'final_exam_terms/destroy')
   Role.find(2).permissions << p
  end

  def self.down
    p = Permission.find_by_name('final_exam_terms/new')
    Role.find(2).permissions.delete(p)
    p.destroy
    p = Permission.find_by_name('final_exam_terms/create')
    Role.find(2).permissions.delete(p)
    p.destroy
    p = Permission.find_by_name('final_exam_terms/destroy')
    Role.find(2).permissions.delete(p)
    p.destroy
  end
end
