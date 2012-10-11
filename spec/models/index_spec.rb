require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe Index do
  context "states" do
    it "should return continues based on specialization study length" do
      index = Index.new
      index.enrolled_on = 3.years.ago
      specialization = Factory(:specialization, :study_length => 4)
      index.specialization = specialization
      index.continues?.should be_false
      index.status.should == I18n::t(:message_15, :scope => [:model, :index])
      index = Index.new
      index.enrolled_on = 3.years.ago
      specialization = Factory(:specialization, :study_length => 3)
      index.specialization = specialization
      index.continues?.should be_true
      index.status.should == I18n::t(:message_14, :scope => [:model, :index])
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

    it "returns payment_code 1 when payment_id set to nil" do
      @index.payment_id = nil
      @index.payment_code.should == 1
    end
  end

  describe "real study duration" do
    subject { Factory(:index, :student => Factory(:student)) }

    context "with interrupts" do
      before :each do
        subject.interrupts << StudyInterrupt.create(:start_on => Time.current,
                                                  :duration => 8)
        Timecop.freeze(Time.zone.local(2011, 1, 2))
      end

      it "should compute real study year" do
        subject.real_study_years.should == 2
      end
    end

    describe "without interrupts" do
      before :each do
        Timecop.freeze(Time.zone.local(2011, 1, 2))
      end

      it "should compute real study year" do
        subject.real_study_years.should == 2
      end
    end

    describe "current year without interrupts" do
      before :each do
        Timecop.freeze(Time.zone.local(2009, 12, 2))
      end

      it "should compute real study year" do
        subject.real_study_years.should == 1
      end
    end

    describe 'absolved' do
      it "should compute real study year" do
        subject.disert_theme = DisertTheme.new(:title => 'test', :finishing_to => 6)
        subject.save
        Timecop.freeze(Time.zone.local(2016, 1, 2))
        subject.disert_theme.defense_passed!('2013-01-02')
        subject.real_study_years.should == 4
      end
    end

    describe 'finished' do
      it "should compute real study year" do
        subject.finished_on = '2014-01-02'
        subject.save
        Timecop.freeze(Time.zone.local(2016, 1, 2))
        subject.real_study_years.should == 5
      end
    end
  end

  describe "study duration" do
    subject { Factory(:index, :student => Factory(:student)) }

    before :each do
      Timecop.freeze(Time.zone.local(2010, 1, 2))
    end

    it "computes semester" do
      subject.semester.should == 1
    end

    it "computes year" do
      subject.year.should == 1
    end

    it "computes nominal length" do
      subject.nominal_length.should == '3 měsíce'
    end

    it "return non started before study start" do
      Timecop.freeze(Time.zone.local(2009, 9, 20))
      subject.nominal_length.should == 'studium ještě nezačalo'
    end

    context "when closing to end" do
      it "returns 10 days" do
        Timecop.freeze(Time.zone.local(2012, 9, 20))
        subject.nominal_length.should == 'zbývá 10 dní'
      end

      it "returns 2 days" do
        Timecop.freeze(Time.zone.local(2012, 9, 28))
        subject.nominal_length.should == 'zbývají 2 dny'
      end

      it "returns last day" do
        Timecop.freeze(Time.zone.local(2012, 9, 30))
        subject.nominal_length.should == 'zbývá poslední den'
      end
    end

    describe "after one more year" do
      before :each do
        Timecop.freeze(Time.zone.local(2011, 1, 2))
      end

      it "should compute semester" do
        subject.semester.should == 3
      end

      it "should compute year" do
        subject.year.should == 2
      end

      it "should compute nominal length" do
        subject.nominal_length.should == '1 rok a 3 měsíce'
      end
    end

    context "with interrupts" do
      before :each do
        subject.interrupts << StudyInterrupt.create(:start_on => Time.current,
                                                  :duration => 8)
        Timecop.freeze(Time.zone.local(2011, 1, 2))
      end

      it "should compute semester" do
        subject.semester.should == 2
      end

      it "should compute year" do
        subject.year.should == 1
      end

      it "should compute nominal length" do
        subject.nominal_length.should == '7 měsíců'
      end
    end

    describe 'absolved' do
      it "should compute semester and year only until absolved date" do
        subject.disert_theme = DisertTheme.new(:title => 'test', :finishing_to => 6)
        subject.save
        Timecop.freeze(Time.zone.local(2016, 1, 2))
        subject.disert_theme.defense_passed!('2013-01-02')
        subject.semester.should == 7
      end
    end
  end

  describe "interrupting" do
    subject { Factory.build(:index, :student => Factory(:student),
                            :study_plan => Factory.build(:study_plan)) }

    context "when too early" do
      it "cannot have interrupt in days" do
        Timecop.freeze(Time.zone. local(2010, 1, 2))
        subject.should_not have_interrupt_from_day
      end
    end

    context "when less than 30 days to end of study" do
      it "can have interrupt from particular day" do
        Timecop.freeze(Time.zone.local(2012, 9, 20))
        subject.should have_interrupt_from_day
      end

      it "can have interrupt in days" do
        Timecop.freeze(Time.zone.local(2012, 10, 20))
        subject.should have_interrupt_from_day
      end
    end

    context "when finishing interrupt" do
      subject { Factory.build(:index, :student => Factory(:student),
                              :study_plan => Factory.build(:study_plan)) }

      it "ends on month's end when does not start on a day" do
        subject.interrupts = [StudyInterrupt.new]
        subject.end_interrupt!({ 'year' => 2012, 'month' => 10 })
        subject.interrupt.finished_on.should == Time.local(2012, 10).end_of_month
      end

      it "ends on date when starts on a day" do
        subject.interrupts = [StudyInterrupt.new(:start_on_day => true)]
        subject.end_interrupt!({ 'year' => 2012, 'month' => 10, 'day' => 3 })
        subject.interrupt.finished_on.should == Time.local(2012, 10, 3)
      end
    end
  end

  context "ImStudent connection" do
    before :each do
      @student = Factory(:student)
      @index = Factory(:index, :student => @student)
    end
    it "prepares ImIndex" do
      @index.prepare_im_index
      @index.im_index.should_not be_nil
    end
    it "should copy attributes to ImIndex" do
      @index.prepare_im_index
      @index.im_index.study_spec.should == @index.specialization.name
    end
    it "should copy attributes when updates" do
      @index.prepare_im_index
      @index.update_attribute(:payment_id, 2)
      @index.update_im_index
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

  context "when validating account" do
    subject { Factory.build(:index, :student => Factory(:student),
                           :account_number => "2303308001") }
    it { should be_valid }

    it "validates incorrect account number" do
      subject.account_number = "3303308001"
      subject.valid?
      subject.errors[:account_number].should_not be_nil
    end

    it "validates correct account number prefix" do
      subject.account_number_prefix = "51"
      subject.should be_valid
    end

    it "validates incorrect account number prefix" do
      subject.account_number_prefix = "52"
      subject.valid?
      subject.errors[:account_number_prefix].should_not be_nil
    end

    it "validates account number prefix with dash as error" do
      subject.account_number_prefix = "0-"
      subject.valid?
      subject.errors[:account_number_prefix].should_not be_nil
    end

    it "validates account number prefix with space as error" do
      subject.account_number_prefix = "0 "
      subject.valid?
      subject.errors[:account_number_prefix].should_not be_nil
    end
  end

  context "with finders" do
    before do
      prepare_scholarships
    end

    it "searches for faculty supervisor" do
      @user.roles << Factory(:role, :name => 'supervisor')
      Index.find_with_scholarship(@user).should == [@index1, @index2, @index3]
    end
    it "searches for faculty secretary" do
      @user.roles << Factory(:role, :name => 'faculty_secretary')
      Index.find_with_scholarship(@user).should == [@index1, @index2]
    end
    it "searches for department secretary" do
      @user.roles << Factory(:role, :name => 'department_secretary')
      Index.find_with_scholarship(@user).should == [@index1]
    end
  end

  context "with paid scholarships" do
    before do
      prepare_scholarships
      ScholarshipMonth.current.pay!
      ScholarshipMonth.current.close!
      ScholarshipMonth.open
    end

    it "returns all paid scholarships" do
      @index1.paid_scholarships.size.should == 2
    end
  end
end

