class RenameScholarshipSupervisedDate < ActiveRecord::Migration
  def self.up
    rename_column :people, :scholarship_supervised_date, 
                  :scholarship_supervised_at
  end

  def self.down
    rename_column :people, :scholarship_supervised_at, 
                  :scholarship_supervised_date
  end
end
