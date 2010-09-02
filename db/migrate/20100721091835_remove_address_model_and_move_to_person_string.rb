class Address < ActiveRecord::Base
  belongs_to :student
end
class AddressType < ActiveRecord::Base; end
class RemoveAddressModelAndMoveToPersonString < ActiveRecord::Migration
  def self.up
    add_column :people, :street, :string
    add_column :people, :desc_number, :string
    add_column :people, :orient_number, :string
    add_column :people, :city, :string
    add_column :people, :zip, :string
    add_column :people, :country, :string
    add_column :people, :postal_street, :string
    add_column :people, :postal_desc_number, :string
    add_column :people, :postal_orient_number, :string
    add_column :people, :postal_city, :string
    add_column :people, :postal_zip, :string
    add_column :people, :postal_country, :string

    Student.reset_column_information

    Address.all.each do |address|
      if student = address.student
        if address.address_type_id == 1
          student.update_attributes(:street => address.street,
            :desc_number => address.desc_number,
            :orient_number => address.orient_number,
            :city => address.city,
            :zip => address.zip,
            :country => address.state)
        else
          student.update_attributes(:postal_street => address.street,
            :postal_desc_number => address.desc_number,
            :postal_orient_number => address.orient_number,
            :postal_city => address.city,
            :postal_zip => address.zip,
            :postal_country => address.state)
        end
      end
    end

    drop_table :addresses
    drop_table :address_types

    %w(save_address edit_street edit_city edit_desc_number edit_zip
      save_street save_city save_desc_number save_zip).each do |page|
      permission = Permission.create(:name => "students/" + page)
      Role.find_by_name('student').permissions << permission
      Role.find_by_name('faculty_secretary').permissions << permission
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end
