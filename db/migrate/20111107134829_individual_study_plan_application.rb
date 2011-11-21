class IndividualStudyPlanApplication < ActiveRecord::Migration
  def self.up
    add_column :indices, :individual_application_note, :text
    add_column :indices, :individual_application_claimed_on, :date
    add_column :indices, :individual_application_result, :boolean
    add_column :indices, :individual_application_decided_at, :date
    Role.find_by_name('student').permissions << Permission.create(:name => 'study_plans/claim_individual')
    Role.find_by_name('student').permissions << Permission.create(:name => 'study_plans/save_claim_individual')
    Role.find_by_name('faculty_secretary').permissions << Permission.create(:name => 'students/claimed_individual')
    Role.find_by_name('faculty_secretary').permissions << Permission.create(:name => 'students/decide_individual')
  end

  def self.down
    remove_column :indices, :individual_application_note
    remove_column :indices, :individual_application_claimed_on
    remove_column :indices, :individual_application_result
    remove_column :indices, :individual_application_decided_at
    per = Permission.first(:name => 'study_plans/claim_individual')
    Role.find_by_name('student').permissions.delete(per)
    per.destroy
    per = Permission.first(:name => 'study_plans/save_claim_individual')
    Role.find_by_name('student').permissions.delete(per)
    per.destroy
    per = Permission.first(:name => 'students/claimed_individual')
    Role.find_by_name('faculty_secretary').permissions.delete(per)
    per.destroy
    per = Permission.first(:name => 'students/decide_individual')
    Role.find_by_name('faculty_secretary').permissions.delete(per)
    per.destroy
  end
end
