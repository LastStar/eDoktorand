class CreateImStudents < ActiveRecord::Migration
  def self.up
    create_table :im_students do |t|
      t.integer :uic
      t.integer :student_id
      t.string :firstname
      t.string :lastname
      t.string :birthname
      t.string :birth_number
      t.string :sex
      t.string :zip
      t.string :street
      t.string :city
      t.date :created_on
      t.date :updated_on
      t.string :title_before
      t.string :title_after
      t.date :birth_on
      t.string :nationality
      t.string :birth_place
      t.string :phone
      t.string :email
      t.string :citizenship
      t.string :qualif_citizenship
      t.string :perm_residence
      t.string :contact_street
      t.string :contact_housenr
      t.string :contact_housenrguid
      t.string :contact_city
      t.string :contact_state
      t.string :contact_zip
      t.string :permaddress_street
      t.string :permaddress_housenr
      t.string :permaddress_housenrguid
      t.string :permaddress_state
      t.string :permaddress_city
      t.string :permaddress_zip
      t.string :marital_status
      t.string :bank_branch
      t.string :bank_account
      t.string :bank_code

      t.timestamps
    end
  end

  def self.down
    drop_table :im_students
  end
end
