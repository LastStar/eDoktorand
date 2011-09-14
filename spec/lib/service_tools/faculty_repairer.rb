require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ServiceTools::FacultyRepairer do
  context "when repairing by short name" do
    before(:each) do
      @faculty = Factory(:faculty, :short_name => 'FAPPZ')
      ServiceTools::FacultyRepairer.repair_all_by_short_name([
        {:name => 'Fakulta agrobiologie, potravinových a přírodních zdrojů',
        :name_english => 'Faculty of Agrobiology, Food and Natural Resources',
        :short_name => 'FAPPZ',
        :code => '41210',
        :ldap_context => 'OU=AF,O=CZU,C=CZ',},
      ])
      @faculty.reload
    end
    it "repairs name" do
      @faculty.name.should == 'Fakulta agrobiologie, potravinových a přírodních zdrojů'
    end
    it "repairs english name" do
      @faculty.name_english.should == 'Faculty of Agrobiology, Food and Natural Resources'
    end
    it "repairs code" do
      @faculty.code.should == '41210'
    end
    it "repairs ldap_context" do
      @faculty.ldap_context.should == 'OU=AF,O=CZU,C=CZ'
    end
  end
  context "when faculty does not exists ind DB yet" do
    it "does not raise error" do
      lambda{ServiceTools::FacultyRepairer.repair_all_by_short_name([
        {:name => 'Fakulta agrobiologie, potravinových a přírodních zdrojů',
        :name_english => 'Faculty of Agrobiology, Food and Natural Resources',
        :short_name => 'FAPPZ',
        :code => '41210',
        :ldap_context => 'OU=AF,O=CZU,C=CZ',},
      ])}.should_not raise_error
    end
  end
end
