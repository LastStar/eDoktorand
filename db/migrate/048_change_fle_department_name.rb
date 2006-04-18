class ChangeFleDepartmentName < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute('SET NAMES UTF8')
    Department.find(63).update_attribute('name', 'Laboratoř ekologie krajiny')
  end

  def self.down
    ActiveRecord::Base.connection.execute('SET NAMES UTF8')
    Department.find(63).update_attribute('name', 'Ústav aplikované ekologie')
  end
end
