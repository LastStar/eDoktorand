class AddStudyLengthToDiplomaSupplement < ActiveRecord::Migration
  def self.up
    add_column :diploma_supplements, :study_length, :integer
  end

  def self.down
    remove_column :diploma_supplements, :study_length
  end
end
