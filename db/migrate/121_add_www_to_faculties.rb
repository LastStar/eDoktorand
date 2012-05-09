class AddWwwToFaculties < ActiveRecord::Migration
  def self.up
    add_column :faculties, :www, :string, :limit => 100
    Faculty.find(1).update_attribute(:www, 'http://www.af.czu.cz/')
    Faculty.find(2).update_attribute(:www, 'http://www.its.czu.cz/')
    Faculty.find(3).update_attribute(:www, 'http://www.fle.czu.cz/')
    Faculty.find(4).update_attribute(:www, 'http://www.pef.czu.cz/')
    Faculty.find(5).update_attribute(:www, 'http://www.tf.czu.cz/')
    Faculty.find(6).update_attribute(:www, 'http://www.ivp.czu.cz/')
    Faculty.find(14).update_attribute(:www, 'http://www.fzp.czu.cz/')
    Faculty.find(15).update_attribute(:www, 'http://www.fld.czu.cz/')
  end

  def self.dowm
    remove_column :faculties, :www
  end
end
