class AddApproveInteruptPermission < ActiveRecord::Migration
  def self.up
    Role.find(4).permissions << Permission.create('name' => 
      'interupts/confirm_approve')
    Role.find(2).permissions << Permission.create('name' =>
      'interupts/confirm')
  end

  def self.down
    permission = Permission.find_by_name('interupts/confirm_approve')
    Role.find(4).permissions.delete(permission)
    permission = Permission.find_by_name('interupts/confirm')
    Role.find(2).permissions.delete(permission)
  end
end
