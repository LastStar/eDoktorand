class AddProgramIdToCoridor < ActiveRecord::Migration
  def self.up
    add_column :coridors, :program_id, :integer
  end

  def self.down
    remove_column :coridors, :program_id
  end
end
