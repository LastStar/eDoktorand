class CreateDefenses < ActiveRecord::Migration
  def self.up
    add_column :indices, :defense_claimed_at, :datetime
    add_column :indices, :defense_invitation_sent_at, :datetime
    add_column :exam_terms, :eighth_examinator, :string
    add_column :exam_terms, :nineth_examinator, :string
    add_column :exam_terms, :second_opponent, :string
    add_column :exam_terms, :third_opponent, :string
    student_role = Role.find_by_name('student')
    secretary_role = Role.find_by_name('faculty_secretary')
    student_role.permissions << Permission.create(:name => 'defenses/claim')
    student_role.permissions << Permission.create(:name => 'defenses/confirm_claim')
    secretary_role.permissions << Permission.create(:name => 'defenses/new')
    secretary_role.permissions << Permission.create(:name => 'defenses/create')
    secretary_role.permissions << Permission.create(:name => 'defenses/list')
    secretary_role.permissions << Permission.create(:name => 'defenses/send_invitation')
    secretary_role.permissions << Permission.create(:name => 'defenses/announcement')
    secretary_role.permissions << Permission.create(:name => 'defenses/protocol')
    permission = Permission.create(:name => 'defenses/show')
    secretary_role.permissions << permission
    student_role.permissions << permission
  end

  def self.down
    remove_column :indices, :defense_claimed_at
    remove_column :indices, :defense_invitation_sent_at
    remove_column :exam_terms, :eighth_examinator
    remove_column :exam_terms, :nineth_examinator
    remove_column :exam_terms, :second_opponent
    remove_column :exam_terms, :third_opponent
    student_role = Role.find_by_name('student')
    secretary_role = Role.find_by_name('faculty_secretary')
    permission = Permission.find_by_name('defenses/claim')
    student_role.permissions.delete permission
    permission.destroy
    permission = Permission.find_by_name('defenses/confirm_claim')
    student_role.permissions.delete permission
    permission.destroy
    permission = Permission.find_by_name('defenses/new')
    secretary_role.permissions.delete permission
    permission.destroy
    permission = Permission.find_by_name('defenses/create')
    secretary_role.permissions.delete permission
    permission.destroy
    permission = Permission.find_by_name('defenses/list')
    secretary_role.permissions.delete permission
    permission.destroy
    permission = Permission.find_by_name('defenses/announcement')
    secretary_role.permissions.delete permission
    permission.destroy
    permission = Permission.find_by_name('defenses/protocol')
    secretary_role.permissions.delete permission
    permission.destroy
    permission = Permission.find_by_name('defenses/show')
    secretary_role.permissions.delete permission
    student_role.permissions.delete permission
    permission.destroy
  end
end
