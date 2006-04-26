class AddFinalExamApprovementToPedagogRoles < ActiveRecord::Migration
  def self.up
    p = Permission.create(:name => 'students/confirm_approve')
    Role.find(4).permissions << p
    Role.find(5).permissions << p
    Role.find(6).permissions << p
  end

  def self.down
    p = Permission.find_by_name('students/confirm_approve')
    Role.find(4).permissions.delete(p)
    Role.find(5).permissions.delete(p)
    Role.find(6).permissions.delete(p)
  end
end
