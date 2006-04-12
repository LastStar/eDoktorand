class UnaccrediteCorridor < ActiveRecord::Migration
  def self.up
    Coridor.find(58).update_attribute('accredited', 0)
  end

  def self.down
    Coridor.find(58).update_attribute('accredited', 1)
  end
end
