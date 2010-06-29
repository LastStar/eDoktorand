require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Study Interrupt" do
  before :all do
    @student = Student.make
    @index = Index.make(:student => @student)
    @index.save
  end

  before :each do
    Timecop.freeze(Time.zone.local(2010, 1, 2))
    @interrupt = StudyInterrupt.create(:index => @index,
                                 :start_on => Time.current,
                                 :duration => 6)
  end

  describe "times and duration" do
    it "should return end on computed from start" do
      @interrupt.end_on.should == Time.zone.local(2010, 6, 30).end_of_month
    end

    it "should recompute start on to beginning of month before validation" do
      @interrupt.start_on.should == Time.current.beginning_of_month
    end

    it "should compute current duration to time now if it not finished" do
      Timecop.freeze(Time.zone.local(2010, 1, 2).end_of_month)
      @interrupt.current_duration.should == 31.days.to_i
    end

    it "should compute current duration to finished on if finished" do
      @interrupt.finish!
      Timecop.freeze(Time.zone.local(2010, 3, 2))
      @interrupt.current_duration.should > 30.days.to_i
    end

    it "should return planned duration if not finished and and end on in past" do
      Timecop.freeze(Time.zone.local(2010, 7, 2))
      @interrupt.current_duration.should == 6.months.to_i
    end

  end

  describe "changing states" do
    it "should be finished" do
      @interrupt.finished?.should be_false
      @interrupt.finish!.should == true
      @interrupt.finished?.should be_true
      @interrupt.finished_on.should == Time.now.end_of_month
    end
  end
end

