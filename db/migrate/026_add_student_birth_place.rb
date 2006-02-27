class AddStudentBirthPlace < ActiveRecord::Migration
  def self.up
    add_column :people, :birth_place, :string
  end

  def self.down
    remove_column :people, :birth_place
  end
end
