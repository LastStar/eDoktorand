class RemoveDepartmentFromTutorship < ActiveRecord::Migration
  def self.up
    remove_column :tutorships, :department_id
  end

  def self.down
    add_column :tutorships, :department_id, :integer

    Tutor.find(:all).select(&:department_employment).each do |t|
      t.tutorship.update_attribute(:department_id, t.department_employment.unit_id)
    end
  end
end
