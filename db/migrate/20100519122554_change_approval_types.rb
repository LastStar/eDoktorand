class ChangeApprovalTypes < ActiveRecord::Migration
  def self.up
    Approval.update_all("type='StudyPlanApproval'", "type='StudyPlanApprovement'")
    Approval.update_all("type='DisertThemeApproval'", "type='DisertThemeApprovement'")
    Approval.update_all("type='FinalExamApproval'", "type='FinalExamApprovement'")
    Approval.update_all("type='ScholarshipApproval'", "type='ScholarshipApprovement'")
    Approval.update_all("type='Attestation'", "type='Atestation'")
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
