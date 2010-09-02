require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe Index do
  context "states" do
    it "should return continues based on specialization study length" do
      index = Index.new
      index.enrolled_on = 3.years.ago
      specialization = Factory(:specialization, :study_length => 4)
      index.specialization = specialization
      index.continues?.should be_false
      index.status.should == I18n::t(:message_15, :scope => [:txt, :model, :index])
      index = Index.new
      index.enrolled_on = 3.years.ago
      specialization = Factory(:specialization, :study_length => 3)
      index.specialization = specialization
      index.continues?.should be_true
      index.status.should == I18n::t(:message_14, :scope => [:txt, :model, :index])
    end
    context 'status methods' do
      before :each do
        @student = Factory(:student)
        @index = Factory(:index, :student => @student)
        Timecop.freeze("2010/01/01")
      end
      it "should return status" do
        @index.status.should == 'studuje'
      end
      it "should return status code" do
        @index.status_code.should == 'S'
      end
      it "should return from when status is valid" do
        @index.status_from.should == Date.parse('2009/09/30')
      end
      it "should return to when status is valid" do
        @index.status_to.should == Date.parse('2010/09/30')
      end
    end
  end

  context "payment type" do
    before :each do
      @student = Factory(:student)
      @index = Factory(:index, :student => @student)
    end
    it "should return payment code" do
      @index.payment_code.should == 1
    end
    it "should return payment type" do
      @index.payment_type.should == 'studium ve standardní době studia'
      @index.payment_id = 2
      @index.payment_type.should == 'cizinec, hrazeno ze zvláštní dotace dle evidence Domu zahr. služeb MŠMT'
    end
  end

  context "study duration" do
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

    describe "with interrupts" do
      before :each do
        @index.interrupts << StudyInterrupt.create(:start_on => Time.current,
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

  context "interrupting" do
    before :all do
      @student = Factory(:student)
    end

    before :each do
      Timecop.freeze(Time.zone.local(2010, 1, 2))
      @index = Factory.build(:index)
      @index.student = @student
    end
  end

  context "ImStudent connection" do
    before :each do
      @student = Factory(:student)
      @index = Factory(:index, :student => @student)
    end
    it "should prepare ImIndex" do
      @index.im_index.should_not be_nil   
    end
    it "should copy attributes to ImIndex" do
      @index.im_index.study_spec.should == @index.specialization.name
    end
    it "should copy attributes when updates" do
      @index.update_attribute(:payment_id, 2)
      @index.im_index.financing_type_code.should == 7
    end
  end
end

