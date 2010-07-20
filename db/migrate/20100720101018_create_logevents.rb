class CreateLogevents < ActiveRecord::Migration
  def self.up
    create_table :logevents do |t|
      t.string :table_key
      t.string :status
      t.integer :event_type
      t.datetime :event_time
      t.string :perpetrator
      t.string :table_name
    end
  end

  def self.down
    drop_table :logevents
  end
end
