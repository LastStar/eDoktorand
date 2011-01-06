require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../lib/service_tools')

describe ServiceTools::Subjects do
  context "with correct data" do
    before(:each) do
      GetSubjectService.should_receive(:get_subjects).and_return(
        [{:code => 'DAAA01Y',
          :label => 'Aplikovana meteorologie a klimatologie',
          :label_en => 'Applied Meteorology and Climatology',
          :department_short_name => 'KET'}])
      Subject.create(:label => 'Bad one', :code => 'DAAA01Y')
      @department = Department.make(:short_name => 'KET')
      ServiceTools::Subjects.repair_all
      @subject = Subject.find_by_code('DAAA01Y')
    end
    it "repairs label" do
      @subject.label.should == 'Aplikovana meteorologie a klimatologie'
    end
    it "repairs english label" do
      @subject.label_en.should == 'Applied Meteorology and Climatology'
    end
    it "adds department to subject" do
      @subject.departments.include?(@department).should be_true
    end
  end
  context "with not correct data" do
    before(:each) do
      GetSubjectService.should_receive(:get_subjects).and_return(
        [{:code => 'DAAA01Y',
          :label => 'Aplikovana meteorologie a klimatologie',
          :label_en => 'Applied Meteorology and Climatology',
          :department_short_name => 'KET'}])
    end
    it "not try to add non existing department" do
      Subject.create(:label => 'Bad one', :code => 'DAAA01Y')
      ServiceTools::Subjects.repair_all
      @subject = Subject.find_by_code('DAAA01Y')
      @subject.departments.include?(@department).should be_false
    end
    it "create non existing subject" do
      ServiceTools::Subjects.repair_all
      @subject = Subject.find_by_code('DAAA01Y')
      @subject.should_not be_nil
      @subject.label.should == 'Aplikovana meteorologie a klimatologie'
    end
  end
end
