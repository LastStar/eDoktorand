require 'spec_helper'

describe IMStudent do
  before(:each) do
    @valid_attributes = {
      :uic => 1,
      :student_id => 1,
      :firstname => "value for firstname",
      :lastname => "value for lastname",
      :birthname => "value for birthname",
      :birth_number => "value for birth_number",
      :sex => "value for sex",
      :zip => "value for zip",
      :street => "value for street",
      :city => "value for city",
      :created_on => Date.today,
      :updated_on => Date.today,
      :title_before => "value for title_before",
      :title_after => "value for title_after",
      :birth_on => Date.today,
      :nationality => "value for nationality",
      :birth_place => "value for birth_place",
      :phone => "value for phone",
      :email => "value for email",
      :citizenship => "value for citizenship",
      :qualif_citizenship => "value for qualif_citizenship",
      :perm_residence => "value for perm_residence",
      :contact_street => "value for contact_street",
      :contact_housenr => "value for contact_housenr",
      :contact_housenrguid => "value for contact_housenrguid",
      :contact_city => "value for contact_city",
      :contact_state => "value for contact_state",
      :contact_zip => "value for contact_zip",
      :permaddress_street => "value for permaddress_street",
      :permaddress_housenr => "value for permaddress_housenr",
      :permaddress_state => "value for permaddress_state",
      :permaddress_city => "value for permaddress_city",
      :permaddress_zip => "value for permaddress_zip",
      :marital_status => "value for marital_status",
      :bank_branch => "value for bank_branch",
      :bank_account => "value for bank_account",
      :bank_code => "value for bank_code"
    }
  end

  it "should create a new instance given valid attributes" do
    IMStudent.create!(@valid_attributes)
  end
end
