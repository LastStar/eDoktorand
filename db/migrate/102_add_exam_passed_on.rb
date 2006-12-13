class AddExamPassedOn < ActiveRecord::Migration
  def self.up
    add_column :exams, :passed_on, :datetime
  end

  def self.down
    remove_column :exams, :passed_on
  end
end
