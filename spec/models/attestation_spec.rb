require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe Index do
  describe "Date computing" do
    before :each do
      Timecop.freeze(Time.zone.local(2010, 1, 2))
      @faculty = Faculty.make
      Object.send(:remove_const, :FACULTY_CFG)
      FACULTY_CFG = {@faculty.id => {'attestation_month' => 3,
                                     'attestation_day' => 15}}
    end

    it "should compute date of next atestation" do
      Attestation.next_for_faculty(@faculty).should == Date.civil(2010, 3, 15)
    end

    it "should compute date of actual atestation" do
      Attestation.actual_for_faculty(@faculty).should == Date.civil(2009, 3, 15)
    end
  end
end

