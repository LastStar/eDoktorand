require "spec_helper"

describe "Study Interrupt" do
  let(:index) { Factory(:index, :student => Factory(:student)) }

  context "when duration in months" do
    subject { StudyInterrupt.create(:index => @index,
                                   :start_on => Date.parse("2010-01-02"),
                                   :duration => 6) }

    context "with times and duration" do
      it { subject.end_on.should == Time.zone.local(2010, 6, 30).end_of_month }

      it { subject.start_on.should == Time.current.beginning_of_month }

      context "when not finished" do
        it "computes current duration to now" do
          Timecop.freeze(Time.zone.local(2010, 1, 2).end_of_month)
          subject.current_duration.should == 31.days.to_i
        end
      end

      context "when finished" do
        it "computes current duration to now" do
          Timecop.freeze(Time.zone.local(2010, 1, 2))
          subject.finish!
          Timecop.freeze(Time.zone.local(2010, 3, 2))
          subject.current_duration.should == 31.days.to_i
        end
      end

      context "when not finished and end on in past" do
        it "returns planned duration" do
          Timecop.freeze(Time.zone.local(2010, 7, 2))
          subject.current_duration.should == 6.months.to_i
        end
      end
    end

    describe "changing states" do
      it { subject.finished?.should be_false }

      context "when finished" do
        before do
          subject.finish!
        end

        it { subject.finished?.should be_true }

        it { subject.finished_on.should == Time.now.end_of_month }
      end
    end
  end

  context "when duration in days" do
    subject {
      StudyInterrupt.create(:index => index,
                            :start_on => Time.current,
                            :duration_in_days => true,
                            :duration => 6)
    }

    before :each do
      Timecop.freeze(Time.zone.local(2012, 9, 20))
    end

    it { should be_valid }

    it { subject.start_on.should == Date.parse("2012-09-20").to_time }

    it { subject.end_on.should == Date.parse("2012-09-25").to_time }
  end

  context "when just builded" do
    subject { index.interrupts.build }

    it { subject.end_on.should be_nil }

    it { subject.current_duration.should == 0 }
  end
end

