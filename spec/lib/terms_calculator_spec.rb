require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe TermsCalculator do
  before :each do
    Timecop.freeze('2010/01/01')
  end
  it "returns start of this school year" do
    TermsCalculator.this_year_start.to_date.should == Date.parse('2009/09/30')
  end
  it "returns end of this school year" do
    TermsCalculator.this_year_end.to_date.should == Date.parse('2010/09/30')
  end
  it "returns start of next school year" do
    TermsCalculator.next_year_start.to_date.should == Date.parse('2010/09/30')
  end
  it "returns end of next school year" do
    TermsCalculator.next_year_end.to_date.should == Date.parse('2011/09/30')
  end
  it "returns next year for IDM" do
    TermsCalculator.idm_next_year.should == '2010'
  end
  it "returns current year for IDM" do
    TermsCalculator.idm_current_year.should == '2009'
  end
end

