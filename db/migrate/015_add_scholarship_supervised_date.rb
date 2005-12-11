class AddScholarshipSupervisedDate < ActiveRecord::Migration
  def self.up
    add_column :people, :scholarship_supervised_date, :datetime
  end

  def self.down
    remove_column :people, :scholarship_supervised_date
  end
end
