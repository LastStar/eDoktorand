require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ServiceTools::Employee do
  context "when repairing by short name" do
    before(:each) do
      Factory(:title, :label => 'RNDr.', :prefix => true)
      Factory(:title, :label => 'DrSc.', :prefix => false)
      @department = Factory(:department, :code => 43150)
      @employee = ServiceTools::Employee.prepare_employee(
        {:uic => '50005',
        :first_name => 'Jaroslav',
        :last_name => 'Weiser',
        :birth_name => 'Weiser',
        :title_before => 'RNDr.',
        :title_after => 'DrSc.',
        :mail => "weiser@fld.czu.cz",
        :phone_line => '3726',
        :department_code => '43150',},
        Tutor.new)
    end
    it "returns tutor" do
      @employee.class.should == Tutor
    end
    it "sets uic" do
      @employee.uic.should == 50005
    end
    it "sets last name" do
      @employee.lastname.should == 'Weiser'
    end
    it "sets first name" do
      @employee.firstname.should == 'Jaroslav'
    end
    it "sets birth name" do
      @employee.birthname.should == 'Weiser'
    end
    it "sets title before" do
      @employee.title_before.label.should == 'RNDr.'
    end
    it "sets title after" do
      @employee.title_after.label.should == 'DrSc.'
    end
    it "sets email" do
      @employee.email.should == 'weiser@fld.czu.cz'
    end
    it "sets phone" do
      @employee.phone.should == '3726'
    end
    it "sets department employment" do
      @employee.department.should == @department
    end
  end
end

