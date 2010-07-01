require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe Index do
  context "states" do
    before(:each) {@index = Index.make(:enrolled_on => 3.years.ago)}
    it "should return continues based on specialization study length" do
      @index.continue?.should be_false
      @index.status.should == :studying
      @index = Index.new
      @index.enrolled_on = 3.years.ago
      @index.specialization = Specialization.make(:study_length => 3)
      @index.continue?.should be_true
      @index.status.should == :continue
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
    it "should return interrupted" do
      @index.interrupt!(1.month.ago)
      @index.should be_interrupted
      @index.status.should == :interrupted
    end
    it "should return finished" do
      @index.finish!(1.month.ago)
      @index.should be_finished
      @index.status.should == :finished
    end
    it "should return passed final exam" do
      @index.final_exam_passed!(1.month.ago)
      @index.should be_final_exam_passed
      @index.status.should == :final_exam_passed
    end
    it "should return absolved" do
      @index.disert_theme = DisertTheme.new(:title => 'test', :finishing_to => 6)
      @index.disert_theme.defense_passed!(1.month.ago)
      @index.should be_absolved
      @index.status.should == :absolved
    end
    it "should return translated status" do
      @index.translated_status.should == "studying"
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

    it "returns payment_code 1 when payment_id set to nil" do
      @index.payment_id = nil
      @index.payment_code.should == 1
    end
  end

  context "study duration" do
    before :all do
      @student = Student.make
    end
  end

  describe "Study duration" do
    before :each do
      Timecop.freeze(Time.zone.local(2010, 1, 2))
      @index = Index.make(:enrolled_on => TermsCalculator.this_year_start)
    end
    describe "Plain" do
      it "should compute semester" do
        @index.semester.should == 1
      end
      it "should compute year" do
        @index.year.should == 1
      end
    end
    describe "After one more year" do
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
    describe "With interrupts" do
      before :each do
        StudyInterrupt.make(:index => @index)
        Timecop.freeze(Time.zone.local(2011, 1, 2))
      end
      it "should compute semester" do
        @index.semester.should == 2
      end
      it "should compute year" do
        @index.year.should == 1
      end
      it "should compute sum time index was interrupted" do
        @index.interrupted_time.should == 8.months
      end
    end
    describe 'Absolved' do
      it "should compute semester and year only until absolved date" do
        @index.disert_theme = DisertTheme.new(:title => 'test', :finishing_to => 6)
        @index.save
        Timecop.freeze(Time.zone.local(2016, 1, 2))
        @index.disert_theme.defense_passed!('2013-01-02')
        @index.semester.should == 7
      end
    end
  end

  describe "Scopes" do
    before(:all) do
      Index.destroy_all
      @index = Index.make
      @tutor = @index.tutor
      @unfinished = Index.make
      @finished = Index.make(:finished_on => Time.now)
      @interrupted = Index.make(:interrupted_on => 1.day.ago)
      @absolved = Index.make
      DisertTheme.make(:defense_passed_on => 1.day.ago, :index => @absolved)
      @not_present = Index.make(:study => Study.make(:name_en => 'combined'))
      @passed_final_exam = Index.make(:final_exam_passed_on => 1.day.ago)
      @all = Index.all
    end

    it "should return all indices tutored by tutor" do
      Index.tutored_by(@tutor).should == [@index]
    end
    it "should return all for faculty" do
      Index.for_faculty(@index.faculty).should == [@index]
    end
    it "should return all for department" do
      Index.for_department(@index.department).should == [@index]
    end
    it "should return all for specialization" do
      Index.for_specialization(@index.specialization).should == [@index]
    end
    it "should return all studying until some date" do
      Index.studying_until(1.day.ago).should == @all - [@absolved]
    end
    it "should return all unfinished till some date" do
      Index.finished_from(1.day.from_now).should == [@finished]
      Index.finished_from(1.day.ago).should == []
    end
    it "should return all enrolled from some date" do
      Index.enrolled_from(1.day.ago).should == @all
    end
    it "should return all not interrupted to some date" do
      Index.not_interrupted_from(Time.now).should == @all - [@interrupted]
      Index.not_interrupted_from(2.days.ago).should == @all
    end
    it "should return all not absolved to some date" do
      Index.not_absolved_from(Time.now).should == @all - [@absolved]
      Index.not_absolved_from(2.day.ago).should == @all
    end
    it "should return all which have passed final exam to some date" do
      Index.passed_final_exam_from(Time.now).should == [@passed_final_exam]
      Index.passed_final_exam_from(2.days.ago).should == []
    end
    it "should return all full time students" do
      Index.full_time.should == @all - [@not_present]
    end
  end

  describe "Properties" do
    before(:each) do
      @index = Index.make
      Study.make(:name_en => 'combined')
    end
    it "should switch study form" do
      @index.should be_present_study
      @index.switch_study!
      @index.should_not be_present_study
    end
  end

  describe "Scholarship questioning" do
    before(:each) do
      @index = Index.make
      Study.make(:name_en => 'combined')
    end
    it "should confirm regular scholarship for full time student" do
      @index.has_regular_scholarship?.should be_true
      @index.switch_study!
      @index.has_regular_scholarship?.should be_false
      @index.switch_study!

    end
    it "should confirm extra scholarship when added" do
      @index.has_extra_scholarship?.should be_false
      @index.switch_study!
      @index.has_extra_scholarship?.should be_false
      ExtraScholarship.make(:index => @index)
      @index.reload
      @index.has_extra_scholarship?.should be_true
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

  context "changing study form" do
    it "has method for changing study form" do
      index = Factory.build(:index, :student => Factory(:student))
      index.switch_study!.should be_true
    end
    it "has method for changing study form" do
      index = Factory.build(:index, :student => Factory(:student))
      index.switched_study?.should be_true
    end
  end

  context "validating account" do
    it "validates correct account number" do
      index = Factory.build(:index, :student => Factory(:student))
      index.account_number = "2303308001"
      index.should be_valid
    end

    it "validates incorrect account number" do
      index = Factory.build(:index, :student => Factory(:student))
      index.account_number = "3303308001"
      index.valid?
      index.errors[:account_number].should_not be_nil
    end

    it "validates correct account number prefix" do
      index = Factory.build(:index, :student => Factory(:student))
      index.account_number = "2303308001"
      index.account_number_prefix = "51"
      index.should be_valid
    end

    it "validates incorrect account number prefix" do
      index = Factory.build(:index, :student => Factory(:student))
      index.account_number = "2303308001"
      index.account_number_prefix = "52"
      index.valid?
      index.errors[:account_number_prefix].should_not be_nil
    end

    it "validates account number prefix with dash as error" do
      index = Factory.build(:index, :student => Factory(:student))
      index.account_number = "2303308001"
      index.account_number_prefix = "0-"
      index.valid?
      index.errors[:account_number_prefix].should_not be_nil
    end

    it "validates account number prefix with space as error" do
      index = Factory.build(:index, :student => Factory(:student))
      index.account_number = "2303308001"
      index.account_number_prefix = "0 "
      index.valid?
      index.errors[:account_number_prefix].should_not be_nil
    end
  end
end

