require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ServiceTools::Specializations do
  context "when repairing by short name" do
    before(:each) do
      @department = Factory(:specialization, :code => 'XINM')
      ServiceTools::Specializations.repair_all_by_code([
        {
          :code => 'XINM',
          :name => 'Informační management',
          :name_english => 'Information Management'
        }
      ])
      @department.reload
    end
    it "repairs name" do
      @department.name.should == 'Informační management'
    end
    it "repairs english name" do
      @department.name_english.should == 'Information Management'
    end
  end
  context "when specialization does not exists ind DB yet" do
    it "does not raise error" do
      lambda{ServiceTools::Specializations.repair_all_by_code([
        {
          :code => 'XINN',
          :name => 'Informační nanagement',
          :name_english => 'Information Nanagement'
        }
      ])}.should_not raise_error
    end
  end
end
