class RenameDeleteAllCandidates < ActiveRecord::Migration
  def self.up
    Permission.find_by_name('candidates/delete_all_candidates').update_attribute(:name, 'candidates/delete_all')
    Permission.find_by_name('candidates/destroy_all_candidates').update_attribute(:name, 'candidates/destroy_all')
  end

  def self.down
    Permission.find_by_name('candidates/delete_all').update_attribute(:name, 'candidates/delete_all_candidates')
    Permission.find_by_name('candidates/destroy_all').update_attribute(:name, 'candidates/destroy_all_candidates')
  end
end
