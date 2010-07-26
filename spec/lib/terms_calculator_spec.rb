require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe TermsCalculator do
  before :each do
    Timecop.freeze('2010/01/01')
  end
  it "should return start of this school year" do
    TermsCalculator.this_year_start.to_date.should == Date.parse('2009/09/30')
  end
  it "should return end of this school year" do
    TermsCalculator.this_year_end.to_date.should == Date.parse('2010/09/30')
  end
end

