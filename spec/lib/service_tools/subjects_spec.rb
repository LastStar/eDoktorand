require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ServiceTools::Subjects do
  context "with correct data" do
    before(:each) do
      @subject = Subject.create(:label => 'Bad one', :code => 'DAAA01Y')
      @department = Factory(:department, :short_name => 'KET')
      ServiceTools::Subjects.repair_all([{:code => 'DAAA01Y',
          :label => 'Aplikovana meteorologie a klimatologie',
          :label_en => 'Applied Meteorology and Climatology',
          :department_short_name => 'KET'}])
      @subject.reload
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
      ServiceTools::Subjects.repair_all([{:code => 'DAAA01Y',
          :label => 'Aplikovana meteorologie a klimatologie',
          :label_en => 'Applied Meteorology and Climatology',
          :department_short_name => 'KET'}])
    end
    it "not try to add non existing department" do
      Subject.create(:label => 'Bad one', :code => 'DAAA01Y')
      @subject = Subject.find_by_code('DAAA01Y')
      @subject.departments.include?(@department).should be_false
    end
    it "create non existing subject" do
      @subject = Subject.find_by_code('DAAA01Y')
      @subject.should_not be_nil
      @subject.label.should == 'Aplikovana meteorologie a klimatologie'
    end
  end
end
