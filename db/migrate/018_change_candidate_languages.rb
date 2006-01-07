class ChangeCandidateLanguages < ActiveRecord::Migration
  def self.up
    rename_column :candidates, :language1, :language1_id 
    rename_column :candidates, :language2, :language2_id 
  end

  def self.down
    rename_column :candidates, :language1_id, :language1
    rename_column :candidates, :language2_id, :language2
  end
end
