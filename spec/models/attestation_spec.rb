require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe Attestation do
  context "for date computing" do
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
  it "should return if it's actual" do
    @study_plan = StudyPlan.make
    @attestation = Attestation.create(:study_plan => @study_plan)
    Timecop.freeze(Time.zone.local(2010, 1, 2))
    FACULTY_CFG = {@study_plan.index.faculty.id =>
                    {'attestation_month' => 3,
                     'attestation_day' => 15}}
    @attestation.should be_actual
    @attestation.updated_on = 1.year.ago
    @attestation.should_not be_actual
  end
  it "should return index of study plan it approves" do
    @study_plan = StudyPlan.make
    @attestation = Attestation.create(:study_plan => @study_plan)
    @attestation.index.should == @study_plan.index
  end
  it "should return document of study plan it approves" do
    @study_plan = StudyPlan.make
    @attestation = Attestation.create(:study_plan => @study_plan)
    @attestation.document.should == @study_plan
  end
end

