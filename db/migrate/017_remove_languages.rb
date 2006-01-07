class RemoveLanguages < ActiveRecord::Migration

  def self.up
    drop_table "languages"
  end

  def self.down
    create_table "languages", :force => true do |t|
      t.column "name", :string, :limit => 50
    end
  end

end
