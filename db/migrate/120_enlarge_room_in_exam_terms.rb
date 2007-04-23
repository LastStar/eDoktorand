class EnlargeRoomInExamTerms < ActiveRecord::Migration
  def self.up
    change_column :exam_terms, :room, :string, :limit => 255
  end

  def self.down
    change_column :exam_terms, :room, :string, :limit => 20
  end
end
