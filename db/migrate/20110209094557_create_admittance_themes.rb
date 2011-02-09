class CreateAdmittanceThemes < ActiveRecord::Migration
  def self.up
    create_table :admittance_themes do |t|
      t.string :name
      t.integer :specialization_id
      t.integer :department_id
      t.integer :tutor_id

      t.timestamps
    end
  end

  def self.down
    drop_table :admittance_themes
  end
end
