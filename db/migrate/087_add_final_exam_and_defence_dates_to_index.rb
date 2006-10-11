class AddFinalExamAndDefenceDatesToIndex < ActiveRecord::Migration
  def self.up
    add_column :indices, :final_exam_passed_on, :date
    add_column :disert_themes, :defense_passed_on, :date
    Role.find(2).permissions << Permission.create(:name => 'students/pass')
    Role.find(2).permissions << Permission.create(:name => 'students/pass_final_exam')
    Role.find(2).permissions << Permission.create(:name => 'students/pass_defense')
  end

  def self.down
    remove_column :indices, :final_exam_passed_on
    remove_column :disert_themes, :defense_passed_on
    per = Permission.find_by_name('students/pass')
    Role.find(2).permissions.delete(per)
    per.destroy
    per = Permission.find_by_name('students/pass_final_exam')
    Role.find(2).permissions.delete(per)
    per.destroy
    per = Permission.find_by_name('students/pass_defense')
    Role.find(2).permissions.delete(per)
    per.destroy
  end
end
