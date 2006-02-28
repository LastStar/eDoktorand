class AddItsCorridors < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute('SET NAMES UTF8')
    Coridor.find(110).update_attribute('accredited', nil)
    add_corridor('faculty_id' => 2, 'id' => 160, 'accredited' => 1, 'code' =>
      '', 'name' => 'Zemědělská mechanizace v tropech a subtropech')
    add_corridor('faculty_id' => 2, 'id' => 161, 'accredited' => 1, 'code' => 
      '', 'name' => 'Ekonomika zemědělství v tropech a subtropech')
    add_corridor('faculty_id' => 2, 'id' => 162, 'accredited' => 1, 'code' =>
      '', 'name' => 'Rostlinná produkce tropů a subtropů')
    add_corridor('faculty_id' => 2, 'id' => 163, 'accredited' => 1, 'code' =>
      '', 'name' => 'Živočišná produkce a potravinářství tropů a subtropů')
  end

  def self.down
    Coridor.find(110).update_attribute('accredited', 1)
    Coridor.find(160, 161, 162, 163).each {|c| c.destroy}
  end

  def self.add_corridor(table)
    c = Coridor.new(table)
    c.id = table['id']
    c.save
  end
end
