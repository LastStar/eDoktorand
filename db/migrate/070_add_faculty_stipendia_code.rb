class AddFacultyStipendiaCode < ActiveRecord::Migration
  def self.up
    add_column :faculties, :stipendia_code, :integer
    Faculty.find(1).update_attribute(:stipendia_code, 21)
    Faculty.find(2).update_attribute(:stipendia_code, 61)
    Faculty.find(3).update_attribute(:stipendia_code, 41)
    Faculty.find(4).update_attribute(:stipendia_code, 11)
    Faculty.find(5).update_attribute(:stipendia_code, 31)
  end

  def self.down
    remove_column :faculties, :stipendia_code
  end
end
