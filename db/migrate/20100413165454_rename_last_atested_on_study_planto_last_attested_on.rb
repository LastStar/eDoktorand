class RenameLastAtestedOnStudyPlantoLastAttestedOn < ActiveRecord::Migration
  def self.up
    rename_column :study_plans, :last_atested_on, :last_attested_on
  end

  def self.down
    rename_column :study_plans, :last_attested_on, :last_atested_on
  end
end
