class AddressToAddresses < ActiveRecord::Migration
  def self.up
    Permission.find(:all,:conditions => "name like 'address/%'").each do |per|
      per.update_attribute(:name, per.name.sub(/.*\//,"addresses/"))
    end
  end

  def self.down
    Permission.find(:all,:conditions => "name like 'addresses/%'").each do |per|
      per.update_attribute(:name, per.name.sub(/.*\//,"address/"))
    end

  end
end
