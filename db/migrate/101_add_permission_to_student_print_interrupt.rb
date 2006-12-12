class AddPermissionToStudentPrintInterrupt < ActiveRecord::Migration
  def self.up
    Role.find(3).permissions <<
      Permission.create(:name => 'interrupts/print_interrupt')
  end

  def self.down
   Role.find(3).permissions.delete
      Permission.find_by_name('interrupts/print_interrupt')
  end

end
