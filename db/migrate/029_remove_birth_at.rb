class RemoveBirthAt < ActiveRecord::Migration
  def self.up
    remove_column :people, :birth_at
  end

  def self.down
    add_column :people, :birth_at, :string
  end
end
