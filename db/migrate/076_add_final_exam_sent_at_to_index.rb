class AddFinalExamSentAtToIndex < ActiveRecord::Migration
  def self.up
    add_column :indices, :final_exam_invitation_sent_at, :datetime
  end

  def self.down
    remove_column :indices, :final_exam_invitation_sent_at
  end
end
