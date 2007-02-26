class AddSupplementPermissions < ActiveRecord::Migration
  def self.up
    Role.find(2).permissions << Permission.create('name' => 'documents/diploma_supplement')
  end

  def self.down
    p = Permission.find_by_name('documents/diploma_supplement')
    Role.find(2).permissions.delete(p)
    p.destroy
  end
end
