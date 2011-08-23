class AddCodeToFaculty < ActiveRecord::Migration
  def self.up
    add_column :faculties, :code, :string
  end

  def self.down
    remove_column :faculties, :code
  end
end
