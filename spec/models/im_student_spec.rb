require 'spec_helper'

describe ImStudent do
  context "creating" do
    it "should have student before saving" do
      im_student = ImStudent.new
      im_student.save.should be_false
    end
    it "should be connected to user" do
      student = Student.new(:firstname => "Josef", :lastname => "Nosek")
      im_student = ImStudent.new(:student => student)
      im_student.student.firstname.should == "Josef"
    end
  end

  context "attribute copying" do
    before(:each) do
      # TODO redone with blueprint after merging with rails3
      @index = Factory.build(:index)
      @student = Student.create(:uic => 1,
                                :firstname => 'Josef',
                                :lastname => 'Nosek',
                                :birthname => 'Kosek',
                                :birth_number => '7604242624',
                                :sex => 'M',
                                :title_before => Title.create(:label => 'Ing.', :prefix => true),
                                :title_after => Title.new(:label => 'PhD.', :prefix => false),
                                :birth_place => 'Liberec',
                                :birth_on => '1980-01-01',
                                :citizenship => 'CZ',
                                :email => 'example@example.com',
                                :phone => '777666555',
                                :street => 'Veverkova',
                                :desc_number => '1410',
                                :orient_number => '8',
                                :city => 'Praha 7',
                                :zip => '17000',
                                :postal_street => 'Reverkova',
                                :postal_desc_number => '2410',
                                :postal_orient_number => '9',
                                :postal_city => 'Praha 9',
                                :postal_zip => '19000',
                                :marital_status => 'single',
                                :index => @index)
      @im_student = ImStudent.new(:student_id => @student.id)
    end

    it "should get students attributes" do
      @im_student.save
      @im_student.uic.should == 1
      @im_student.lastname.should == 'Nosek'
      @im_student.firstname.should == 'Josef'
      @im_student.birthname.should == 'Kosek'
      @im_student.birth_number.should == '7604242624'
      @im_student.sex.should == 'M'
      @im_student.created_on.to_i.should == @student.created_on.to_i
      @im_student.title_before.should == 'Ing.'
      @im_student.title_after.should == 'PhD.'
      @im_student.birth_place.should == 'Liberec'
      @im_student.birth_on.should == Date.parse('1980-01-01')
      @im_student.email.should == 'example@example.com'
      @im_student.phone.should == '777666555'
      @im_student.citizenship.should == 'CZ'
      @im_student.qualif_citizenship.should == '203'
      @im_student.permaddress_street.should == 'Veverkova'
      @im_student.permaddress_housenr.should == '1410'
      @im_student.permaddress_housenrguid.should == '8'
      @im_student.permaddress_city.should == 'Praha 7'
      @im_student.permaddress_zip.should == '17000'
      @im_student.contact_street.should == 'Reverkova'
      @im_student.contact_housenr.should == '2410'
      @im_student.contact_housenrguid.should == '9'
      @im_student.contact_city.should == 'Praha 9'
      @im_student.contact_zip.should == '19000'
      @im_student.marital_status.should == 'single'
    end
    it "should get attributes from students index" do
      @im_student.save
      @im_student.bank_branch.should == '35'
      @im_student.bank_account.should == '2303308001'
      @im_student.bank_code.should == '5500'
    end
  end
end
