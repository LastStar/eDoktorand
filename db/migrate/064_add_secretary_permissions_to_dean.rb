class AddSecretaryPermissionsToDean < ActiveRecord::Migration
  def self.up
    np = Role.find(2).permissions - Role.find(5).permissions
    Role.find(5).permissions << np
  end

  def self.down
    raise IrreversibleMigration
  end
end
