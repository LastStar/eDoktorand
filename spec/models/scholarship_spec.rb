require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Scholarship do
  let(:scholarship) {Scholarship.new}
  it "has relation to scholarship month" do
    scholarship.scholarship_month = ScholarshipMonth.open
  end
  it "deprecates payed on attribute" do
    scholarship.payed_on.should == 'Deprecated. Paying through month'
  end
  it "deprecates approved on attribute" do
    scholarship.payed_on.should == 'Deprecated. Paying through month'
  end
end


