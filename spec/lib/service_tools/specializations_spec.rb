require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ServiceTools::Specializations do
  context "when repairing by short name" do
    before(:each) do
      @department = Factory(:specialization, :msmt_code => '4107V013', :locale => 'cz')
      ServiceTools::Specializations.repair_all_by_code([
        {
          :msmtCode => '4107V013',
          :shortName => "XOCHMY",
          :nameCz => 'Ochrana lesů a myslivost',
          :nameEn => 'Forest Protection and Game Management',
          :language => "CZE"
        }
      ])
      @department.reload
    end

    it "repairs name" do
      @department.name.should == 'Ochrana lesů a myslivost'
    end

    it "repairs english name" do
      @department.name_english.should == 'Forest Protection and Game Management'
    end

    it "repairs code" do
      @department.code.should == 'XOCHMY'
    end
  end

  context "when specialization does not exists ind DB yet" do
    it "does not raise error" do
      lambda{ServiceTools::Specializations.repair_all_by_code([
        {
          :msmtCode => 'T107V013',
          :shortName => "XOCHMY",
          :nameCz => 'Ochrana lesů a myslivost',
          :nameEn => 'Forest Protection and Game Management',
          :language => "CZE"
        }
      ])}.should_not raise_error
    end
  end
end
