require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe Index do
  describe "states" do
    it "should return continues based on coridor study length" do
      i = Index.new
      i.enrolled_on = 3.years.ago
      c = Factory(:coridor, :study_length => 4)
      i.coridor = c
      i.continues?.should be_false
      i.status.should == I18n::t(:message_15, :scope => [:txt, :model, :index])
      i = Index.new
      i.enrolled_on = 3.years.ago
      c = Factory(:coridor, :study_length => 3)
      i.coridor = c
      i.continues?.should be_true
      i.status.should == I18n::t(:message_14, :scope => [:txt, :model, :index])
    end
  end

  describe "study duration" do
    before :all do
      @student = Factory(:student)
    end

    before :each do
      Timecop.freeze(Time.zone.local(2010, 1, 2))
      @index = Factory.build(:index)
      @index.student = @student
    end

    it "should compute semester" do
      @index.semester.should == 1
    end

    it "should compute year" do
      @index.year.should == 1
    end

    describe "after one more year" do
      before :each do
        Timecop.freeze(Time.zone.local(2011, 1, 2))
      end

      it "should compute semester" do
        @index.semester.should == 3
      end

      it "should compute year" do
        @index.year.should == 2
      end
    end

    describe "with interupts" do
      before :each do
        @index.interupts << Interupt.create(:start_on => Time.current,
                                            :duration => 8)
        Timecop.freeze(Time.zone.local(2011, 1, 2))
      end

      it "should compute semester" do
        @index.semester.should == 2
      end

      it "should compute year" do
        @index.year.should == 1
      end
    end

    describe 'absolved' do
      it "should compute semester and year only until absolved date" do
        @index.disert_theme = DisertTheme.new(:title => 'test', :finishing_to => 6)
        @index.save
        Timecop.freeze(Time.zone.local(2016, 1, 2))
        @index.disert_theme.defense_passed!('2013-01-02')
        @index.semester.should == 7
      end
    end
  end

  describe "interupting" do
    before :all do
      @student = Factory(:student)
    end

    before :each do
      Timecop.freeze(Time.zone.local(2010, 1, 2))
      @index = Factory.build(:index)
      @index.student = @student
    end
  end
end

