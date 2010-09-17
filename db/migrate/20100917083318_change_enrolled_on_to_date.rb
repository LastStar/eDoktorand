class ChangeEnrolledOnToDate < ActiveRecord::Migration
  def self.up
    change_column(:indices, :enrolled_on, :date)
  end

  def self.down
    change_column(:indices, :enrolled_on, :date_time)
  end
end
