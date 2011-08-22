require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ServiceTools::Programs do
  context "when repairing by short name" do
    before(:each) do
      @department = Factory(:program, :code => 'P6209')
      ServiceTools::Programs.repair_all_by_code([
        {
          :code => 'P6209',
          :name => 'Systémové inženýrství a informatika',
          :name_english => 'Engineering and Informatics',
          :guarantee_uic => '50005'
        }
      ])
      @department.reload
    end
    it "repairs name" do
      @department.name.should == 'Systémové inženýrství a informatika'
    end
    it "repairs english name" do
      @department.name_english.should == 'Engineering and Informatics'
    end
  end
  context "when program does not exists ind DB yet" do
    it "does not raise error" do
      lambda{ServiceTools::Programs.repair_all_by_code([
        {
          :code => 'P6209',
          :name => 'Systémové inženýrství a informatika',
          :name_english => 'Engineering and Informatics'
        }
      ])}.should_not raise_error
    end
  end
end
