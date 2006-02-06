class AddAdmittanceCorridors < ActiveRecord::Migration

  def self.up
    ActiveRecord::Base.connection.execute('SET NAMES UTF8')
    add_column :coridors, :accredited, :integer, :limit => 1

    Coridor.find(110).update_attributes('name' => 'Zemědělství tropů a subtropů', 'accredited' => 1) # ITSZ
    Coridor.find_all_by_faculty_id(3).each {|c| c.update_attribute('accredited', 1) } # LF
    Coridor.find(106, 50, 129, 107, 23).each {|c| c.update_attribute('accredited', 1) } # TF
    Coridor.find(11, 12, 13, 15, 16).each {|c| c.update_attribute('accredited', 1) } # PEF
    # AF
    add_corridor('faculty_id' => 1, 'id' => 150, 'accredited' => 1, 'code' => '4102V002', 'name' => 'Obecná produkce rostlinná')
    add_corridor('faculty_id' => 1, 'id' => 151, 'accredited' => 1, 'code' => '4102V008', 'name' => 'Speciální produkce rostlinná')
    add_corridor('faculty_id' => 1, 'id' => 152, 'accredited' => 1, 'code' => '4103V002', 'name' => 'Obecná zootechnika')
    add_corridor('faculty_id' => 1, 'id' => 153, 'accredited' => 1, 'code' => '4103V004', 'name' => 'Speciální zootechnika')
    add_corridor('faculty_id' => 1, 'id' => 154, 'accredited' => 1, 'code' => '4106V011', 'name' => 'Zemědělská a lesnická fytopatologie a ochrana rostlin')
    add_corridor('faculty_id' => 1, 'id' => 155, 'accredited' => 1, 'code' => '4106V017', 'name' => 'Zemědělská chemie')
    add_corridor('faculty_id' => 4, 'id' => 156, 'accredited' => 1, 'code' => '', 'name' => 'Management')
    add_corridor('faculty_id' => 4, 'id' => 157, 'accredited' => 1, 'code' => '', 'name' => 'Sector Economics and Economics of Enterprise')
  end

  def self.down
    ActiveRecord::Base.connection.execute('SET NAMES UTF8')
    remove_column :coridors, :accredited
    Coridor.find(110).update_attribute('name', 'Tropické a subtropické zemědělství ITSZ')
    Coridor.find(150, 151, 152, 153, 154, 155, 156, 157).each {|c| c.destroy }
  end

  def self.add_corridor(table)
    c = Coridor.new(table)
    c.id = table['id']
    c.save
  end

end
