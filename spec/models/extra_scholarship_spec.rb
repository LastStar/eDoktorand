require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RegularScholarship do
  context "when searching" do
    before do
      @index = Factory(:index, :student => Factory(:student))
      @scholarship = ExtraScholarship.create(:index => @index, :amount => '1000', :commission_head => '1234',
                      :commission_body => '12345', :commission_tail => '1234',
                      :scholarship_month => ScholarshipMonth.open)
    end
    it "returns all unpaid by index" do
      ExtraScholarship.find_all_unpaid_by_index(@index).should == [@scholarship]
    end
  end
  context "with csv row" do
    before do
      Timecop.freeze(Date.parse('2012-02-02'))
      @index = Factory(:index, :student => Factory(:student))
      @scholarship = ExtraScholarship.create(:index => @index, :amount => '1000', :commission_head => '1234',
                      :commission_body => '12345', :commission_tail => '1234',
                      :scholarship_month => ScholarshipMonth.open)
    end
    it "returns csv row" do
      @scholarship.csv_row.should == [@index.student.sident, '66DTUM',  '1234123451234', 1000.0,
        nil, nil, nil, '201202']
    end
  end
end

