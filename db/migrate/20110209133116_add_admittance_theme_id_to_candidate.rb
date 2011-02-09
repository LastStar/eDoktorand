class AddAdmittanceThemeIdToCandidate < ActiveRecord::Migration
  def self.up
    add_column :candidates, :admittance_theme_id, :integer
  end

  def self.down
    remove_column :candidates, :admittance_theme_id
  end
end
