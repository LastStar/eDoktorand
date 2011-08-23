require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ServiceTools::DepartmentRepairer do
  context "when repairing by short name" do
    before(:each) do
      @department = Factory(:department, :short_name => 'KM')
      ServiceTools::DepartmentRepairer.repair_all_by_short_name([
        {
          :name => 'Katedra matematiky',
          :name_english => 'Department of Mathematics',
          :short_name => 'KM',
          :code => '31110',
          :faculty_id => '5',
          :faculty_code => '41310',
          :type_id => '1'
        }
      ])
      @department.reload
    end
    it "repairs name" do
      @department.name.should == 'Katedra matematiky'
    end
    it "repairs english name" do
      @department.name_english.should == 'Department of Mathematics'
    end
    it "repairs code" do
      @department.code.should == '31110'
    end
  end
  context "when unit is not department" do
    it "does not raise error" do
      lambda{ServiceTools::DepartmentRepairer.repair_all_by_short_name([
        {
          :name => 'Proste utvar',
          :name_english => 'Some unit',
          :short_name => 'SU',
          :code => '666',
          :type_id => '5'
        }
      ])}.should_not raise_error
    end
  end
  context "when department does not exists ind DB yet" do
    it "does not raise error" do
      lambda{ServiceTools::DepartmentRepairer.repair_all_by_short_name([
        {
          :name => 'Katedra alter matematiky',
          :name_english => 'Department of Alter Mathematics',
          :short_name => 'KALTM',
          :code => '31119',
          :faculty_id => '5',
          :faculty_code => '41310',
          :type_id => '1'
        }
      ])}.should_not raise_error
    end
  end
end
