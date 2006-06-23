class AddAddressEditSaveItemsPermisison < ActiveRecord::Migration
  def self.up
    Role.find(3).permissions << Permission.create('name' => 'address/edit_street')
    Role.find(3).permissions << Permission.create('name' => 'address/save_street')
    Role.find(3).permissions << Permission.create('name' => 'address/edit_city')
    Role.find(3).permissions << Permission.create('name' => 'address/save_city')
    Role.find(3).permissions << Permission.create('name' => 'address/edit_desc_number')
    Role.find(3).permissions << Permission.create('name' => 'address/save_desc_number')
    Role.find(3).permissions << Permission.create('name' => 'address/edit_zip')
    Role.find(3).permissions << Permission.create('name' => 'address/save_zip')
    Role.find(3).permissions << Permission.create('name' => 'scholarships/save_email')
    Role.find(3).permissions << Permission.create('name' => 'scholarships/edit_email')
    Role.find(3).permissions << Permission.create('name' => 'scholarships/save_phone')
    Role.find(3).permissions << Permission.create('name' => 'scholarships/edit_phone')
    Role.find(3).permissions << Permission.create('name' => 'scholarships/save_citizenship')
    Role.find(3).permissions << Permission.create('name' => 'scholarships/edit_citizenship')

  end

  def self.down
    Role.find(3).permissions.delete(Permission.find_by_name('address/edit_street').destroy)
    Role.find(3).permissions.delete(Permission.find_by_name('address/save_street').destroy)
    Role.find(3).permissions.delete(Permission.find_by_name('address/edit_desc_number').destroy)
    Role.find(3).permissions.delete(Permission.find_by_name('address/save_desc_number').destroy)
    Role.find(3).permissions.delete(Permission.find_by_name('address/edit_city').destroy)
    Role.find(3).permissions.delete(Permission.find_by_name('address/save_city').destroy)
    Role.find(3).permissions.delete(Permission.find_by_name('address/edit_zip').destroy)
    Role.find(3).permissions.delete(Permission.find_by_name('address/save_zip').destroy)
    Role.find(3).permissions.delete(Permission.find_by_name('scholarships/save_email').destroy)
    Role.find(3).permissions.delete(Permission.find_by_name('scholarships/edit_email').destroy)
    Role.find(3).permissions.delete(Permission.find_by_name('scholarships/save_phone').destroy)
    Role.find(3).permissions.delete(Permission.find_by_name('scholarships/edit_phone').destroy)
    Role.find(3).permissions.delete(Permission.find_by_name('scholarships/save_citizenship').destroy)
    Role.find(3).permissions.delete(Permission.find_by_name('scholarships/edit_citizenship').destroy)
  end
end
