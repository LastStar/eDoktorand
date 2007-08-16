class AddDocumentIdIndexToApprovement < ActiveRecord::Migration
  def self.up
    add_index :approvements, :document_id
  end

  def self.down
    remove_index :approvements, :document_id
  end
end
