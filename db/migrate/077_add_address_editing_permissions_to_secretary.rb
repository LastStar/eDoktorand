class AddAddressEditingPermissionsToSecretary < ActiveRecord::Migration
  def self.up
    Role.find(2).permissions <<
      Permission.find_by_name('addresses/edit_street')
    Role.find(2).permissions <<
      Permission.find_by_name('addresses/save_street')
    Role.find(2).permissions <<
      Permission.find_by_name('addresses/edit_city')
    Role.find(2).permissions <<
      Permission.find_by_name('addresses/save_city')
    Role.find(2).permissions <<
      Permission.find_by_name('addresses/edit_zip')
    Role.find(2).permissions <<
      Permission.find_by_name('addresses/save_zip')
    Role.find(2).permissions <<
      Permission.find_by_name('addresses/edit_desc_number')
    Role.find(2).permissions <<
      Permission.find_by_name('addresses/save_desc_number')
  end

  def self.down
    Role.find(2).permissions.delete(
      Permission.find_by_name('addresses/edit_street'))
    Role.find(2).permissions.delete(
      Permission.find_by_name('addresses/save_street'))
    Role.find(2).permissions.delete(
      Permission.find_by_name('addresses/edit_city'))
    Role.find(2).permissions.delete(
      Permission.find_by_name('addresses/save_city'))
    Role.find(2).permissions.delete(
      Permission.find_by_name('addresses/edit_zip'))
    Role.find(2).permissions.delete(
      Permission.find_by_name('addresses/save_zip'))
    Role.find(2).permissions.delete(
      Permission.find_by_name('addresses/edit_desc_number'))
    Role.find(2).permissions.delete(
      Permission.find_by_name('addresses/save_desc_number'))
  end
end
