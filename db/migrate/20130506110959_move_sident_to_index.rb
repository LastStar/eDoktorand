class MoveSidentToIndex < ActiveRecord::Migration
  def self.up
    add_column :indices, :sident, :string
    Student.all(:conditions => "sident is not null").each do |s|
      next unless s.index
      s.index.update_attribute(:sident, s.sident)
    end
    remove_column :people, :sident
  end

  def self.down
    add_column :people, :sident, :string
    Index.all(:conditions => "sident is not null").each do |i|
      i.student.update_attribute(:sident,  i.sident) if i.index
    end
    remove_column :indices, :sident
  end
end
