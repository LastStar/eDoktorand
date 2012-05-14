require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RegularScholarship do
  before do
    ScholarshipMonth.destroy_all
    ExtraScholarship.destroy_all
  end

  context "when searching" do
    before do
      @index = Factory(:index, :student => Factory(:student))
      @scholarship = RegularScholarship.create(:index => @index,
                                :scholarship_month => ScholarshipMonth.open)
    end
    it "returns all unpaid by index" do
      RegularScholarship.find_unpaid_by_index(@index).should == @scholarship
    end
  end
  context "with csv row" do
    before do
      Timecop.freeze(Date.parse('2012-02-02'))
      @index = Factory(:index, :student => Factory(:student))
      @scholarship = RegularScholarship.create(:index => @index,
                                :scholarship_month => ScholarshipMonth.open)
    end
    it "returns csv row" do
      @scholarship.csv_row.should == [@index.student.sident, '66DTUR',  '12016661121', 0.0,
        nil, nil, nil, '201202']
    end
  end
end

