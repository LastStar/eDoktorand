require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ScholarshipMonth do
  before do
    ScholarshipMonth.delete_all
  end
  context "with basic operations" do
    let(:month) {ScholarshipMonth.new}
    it "can be initilized" do
      month.should_not be_nil
    end
  end
  context "when opening" do
    let(:month) do
      Timecop.freeze(Date.parse('2012-02-02'))
      @month = ScholarshipMonth.open
    end
    it "is opened" do
      month.should be_opened
    end
    it "is saved on opening" do
      month.should_not be_new_record
    end
    it "starts on the begining of current month" do
      month.starts_on.should == Date.parse('2012-02-1')
    end
  end
  context "when paying" do
    let(:month) {ScholarshipMonth.open}
    it "can be paid" do
      month.pay!
      month.should be_paid
    end
    it "can be unpaid" do
      month.pay!
      month.unpay!
      month.should_not be_paid
    end
  end
  context "when closing" do
    let(:month) {ScholarshipMonth.open}
    it "cannot be closed before it is paid" do
      month.close!.should be_false
    end
    it "can be closed when it is paid" do
      month.pay!
      month.close!.should be_true
    end
    it "prepares new month" do
      month.pay!
      month.close!
      ScholarshipMonth.current.should_not be_nil
    end
  end
  context "with title" do
    it "creates title from date of opening" do
      Timecop.freeze(Date.parse('2012-02-02'))
      ScholarshipMonth.open.title.should == '201202'
    end
  end
  context "with current" do
    it "can find current month" do
      @month = ScholarshipMonth.open
      ScholarshipMonth.current.should == @month
    end
    it "does not create another when one still not closed" do
      ScholarshipMonth.open
      ScholarshipMonth.open
      ScholarshipMonth.count.should == 1
    end
  end
  context "with scholarships" do
    let(:month) {ScholarshipMonth.open}
    before do
      prepare_scholarships
    end
    it "it has many scholarships" do
      month.scholarships.count.should == 3
    end
  end
  context "when opening with prior month had scholarships" do
    before do
      prepare_scholarships
    end
    it "prepares new regular scholarships " do
      ScholarshipMonth.current.pay!
      ScholarshipMonth.current.close!
      Timecop.freeze(Date.parse('2012-02-02'))
      ScholarshipMonth.current.scholarships.size.should == 2
    end
  end
end
