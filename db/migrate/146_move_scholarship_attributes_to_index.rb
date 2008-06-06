class MoveScholarshipAttributesToIndex < ActiveRecord::Migration
  def self.up
    add_column :indices, :scholarship_claimed_at, :datetime
    add_column :indices, :scholarship_approved_at, :datetime
    add_column :indices, :scholarship_canceled_at, :datetime
    Student.find(:all).each do |student|
      if index = student.index
        index.scholarship_claimed_at = student.scholarship_claimed_at
        index.scholarship_approved_at = student.scholarship_supervised_at
        index.save
      end
    end
    remove_column :people, :scholarship_claimed_at
    remove_column :people, :scholarship_supervised_at
    role = Role.find_by_name('faculty_secretary')
    permission = Permission.find_by_name('students/supervise_scholarship_claim')
    role.permissions.delete(permission)
    permission = Permission.create(:name => 'students/approve_scholarship_claim')
    role.permissions << permission
    permission = Permission.create(:name => 'students/cancel_scholarship_claim')
    role.permissions << permission
  end

  def self.down
    ActiveRecord::Base.connection.execute('SET NAMES UTF8')
    add_column :people, :scholarship_claimed_at, :datetime
    add_column :people, :scholarship_supervised_at, :datetime
    Student.find(:all).each do |student|
      if index = student.index
        student.scholarship_claimed_at = index.scholarship_claimed_at 
        student.scholarship_supervised_at = index.scholarship_approved_at 
        student.save
      end
    end
    remove_column :indices, :scholarship_claimed_at
    remove_column :indices, :scholarship_approved_at
    remove_column :indices, :scholarship_canceled_at
    role = Role.find_by_name('faculty_secretary')
    permission = Permission.find_by_name('students/approve_scholarship_claim')
    role.permissions.delete(permission)
    permission = Permission.find_by_name('students/cancel_scholarship_claim')
    role.permissions.delete(permission)
    permission = Permission.create(:name => 'students/supervise_scholarship_claim')
    role.permissions << permission
  end
end
