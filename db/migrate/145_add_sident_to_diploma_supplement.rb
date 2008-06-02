class AddSidentToDiplomaSupplement < ActiveRecord::Migration
  def self.up
    add_column :diploma_supplements, :sident, :integer
  end

  def self.down
    remove_column :diploma_supplements, :sident
  end
end
