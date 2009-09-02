class CreateExternalChairmanTutors < ActiveRecord::Migration
  def self.up
     Tutor.create(:firstname => "externi", :lastname => "predseda")
  end

  def self.down
    externi_predseda = Tutor.find_by_firstname_and_lastname("externi","predseda")
    externi_predseda.destroy
  end
end
