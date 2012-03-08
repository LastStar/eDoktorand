class ChangeEightExaminatorToEighth < ActiveRecord::Migration
  def self.up
    rename_column :exam_terms, :eight_examinator_email, :eighth_examinator_email
  end

  def self.down
    rename_column :exam_terms, :eighth_examinator_email, :eight_examinator_email
  end
end
