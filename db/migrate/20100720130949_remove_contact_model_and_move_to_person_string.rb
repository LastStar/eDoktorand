class Contact < ActiveRecord::Base
  belongs_to :contact_type, :foreign_key => :contact_type_id
  belongs_to :person
end
class ContactType < ActiveRecord::Base; end

class RemoveContactModelAndMoveToPersonString < ActiveRecord::Migration
  def self.up
    add_column :people, :email, :string
    add_column :people, :phone, :string

    Contact.all.each do |contact|
      if contact.contact_type_id == 1 && contact.person
        contact.person.update_attribute(:email, contact.name)
      elsif contact.person
        contact.person.update_attribute(:phone, contact.name)
      end
    end

    drop_table :contacts
    drop_table :contact_types
  end

  def self.down
    raise IrreversibleMigration
  end
end
