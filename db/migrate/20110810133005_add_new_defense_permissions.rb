class AddNewDefensePermissions < ActiveRecord::Migration
  def self.up
    Role.find_by_name('faculty_secretary').permissions << Permission.create('name' => 'final_exam_terms/pass')
    Role.find_by_name('faculty_secretary').permissions << Permission.create('name' => 'final_exam_terms/save_pass')
    Role.find_by_name('faculty_secretary').permissions << Permission.create('name' => 'defenses/pass')
    Role.find_by_name('faculty_secretary').permissions << Permission.create('name' => 'defenses/save_pass')
  end

  def self.down
    permission = Permission.find_by_name('final_exam_terms/pass')
    Role.find_by_name('faculty_secretary').permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('final_exam_terms/save_pass')
    Role.find_by_name('faculty_secretary').permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('defenses/pass')
    Role.find_by_name('faculty_secretary').permissions.delete(permission)
    permission.destroy
    permission = Permission.find_by_name('defenses/save_pass')
    Role.find_by_name('faculty_secretary').permissions.delete(permission)
    permission.destroy
  end
end
