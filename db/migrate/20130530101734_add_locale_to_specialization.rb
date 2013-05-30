class AddLocaleToSpecialization < ActiveRecord::Migration
  def self.up
    add_column :specializations, :locale, :string, :default => "cz"
    Specialization.all(:conditions => "name = name_english and faculty_id = 14").each { |s| s.update_attribute(:locale, 'en') }
    Parameter.create(:name => "admittance_invitation_time_and_place_en",
                     :faculty_id => 14,
                     :value => "Applicants who have outlined the topic of their dissertation in co-operation with their potential advisor will meet at 9.00 a.m. in the conference room at FES, No. 239 (the new MCEV building), where they will receive general information." )
  end

  def self.down
    remove_column :specializations, :locale
  end
end
