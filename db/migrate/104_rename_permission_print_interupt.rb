class RenamePermissionPrintInterupt < ActiveRecord::Migration
  def self.up
    Role.find(3).permissions.delete
      Permission.find_by_name('interrupts/print_interrupt')
    Role.find(3).permissions <<
      Permission.create(:name => 'interupts/print_interupt')
  end

  def self.down
    Role.find(3).permissions <<
      Permission.create(:name => 'interrupts/print_interrupt')
    Role.find(3).permissions.delete
      Permission.find_by_name('interupts/print_interupt')

  end
end
