class CreateImIdentities < ActiveRecord::Migration
  def self.up
    create_table :im_identities do |t|
      t.integer :id
      t.integer :uic
      t.string :loginname
      t.string :init_pwd
      t.string :init_pwd_gw
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :im_identities
  end
end
