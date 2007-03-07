class CreatePrograms < ActiveRecord::Migration
  def self.up
    create_table :programs do |t|
      t.column "label", :string
      t.column "label_en", :string
    end
  end

  def self.down
    drop_table :programs
  end
end
