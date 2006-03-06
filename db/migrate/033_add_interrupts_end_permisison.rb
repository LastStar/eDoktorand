class AddInterruptsEndPermisison < ActiveRecord::Migration
  def self.up
    Role.find(2).permissions << Permission.create('name' => 'interupts/end')
  end

  def self.down
    Role.find(2).permissions.delete(Permission.find_by_name('interupts/end').destroy)
  end
end
