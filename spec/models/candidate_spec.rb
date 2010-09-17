require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Candidate" do
  before(:all) do
    @faculty = Faculty.make
    @specialization = Specialization.make(:faculty => @faculty)
  end

  it 'enrolls a return new student with index' do
    mock_uic_getter = mock(UicGetter)
    UicGetter.should_receive(:new).and_return(mock_uic_getter)
    mock_uic_getter.should_receive(:get_uic).with('7604242624').and_return(1)
    candidate = Candidate.make(:postal_street => 'Short')
    candidate.tutor = Tutor.make
    candidate.specialization = Specialization.make
    candidate.study = Study.make
    student = candidate.new_student('2010-01-01')
    student.uic.should == 1
    student.firstname.should == 'Karel'
    student.lastname.should == 'Marel'
    student.birth_on.should == candidate.birth_on
    student.birth_number.should == candidate.birth_number
    student.state.should == 'CZ'
    student.citizenship.should == 'CZ'
    student.birth_place.should == candidate.birth_at
    student.title_before.should == candidate.title_before
    student.title_after.should == candidate.title_after
    student.street.should == candidate.street
    student.desc_number.should == candidate.number
    student.city.should == candidate.city
    student.country.should == candidate.address_state
    student.postal_street.should == candidate.postal_street
    student.email.should == 'karel@marel.cz'
    student.phone.should == candidate.phone
    student.sex.should == 'M'
    student.marital_status.should == 'S'
    student.index.department == candidate.department
    student.index.specialization == candidate.specialization
    student.index.tutor == candidate.tutor
    student.index.study == candidate.study
    student.index.student == candidate.student
    student.index.enrolled_on.should == Date.parse('2010-01-01')
    student.index.tutor.should == candidate.tutor
    student.index.payment_id.should == 1
    candidate.student.should == student
  end

  it "strips all spaces from birth number" do
    candidate = Candidate.make(:birth_number => '7604242624 ')
    candidate.save
    candidate.reload
    candidate.birth_number.should == '7604242624'
  end

  it "toggles foreign payment" do
    candidate = Candidate.make
    candidate.toggle_foreign_pay
    candidate.should be_foreign_pay
    candidate.toggle_foreign_pay
    candidate.should_not be_foreign_pay
  end

  context "Retrieving" do
    before(:each) do
      Candidate.make
      @specialized = Candidate.make(:specialization => @specialization)
      @finished = Candidate.make(:finished, :specialization => @specialization)
      @ready = Candidate.make(:ready)
      @invited = Candidate.make(:invited)
      @admitted = Candidate.make(:admitted)
    end
    it "should return candidates for faculty" do
      candidates = Candidate.for_faculty(@faculty)
      candidates.should_not be_empty
      candidates.for_faculty(@faculty).count.should < Candidate.all.count
    end
    it "should return all finished candidates" do
      Candidate.finished.should == [@finished, @ready, @invited, @admitted]
    end
    it "should combine finished and from faculty" do
      Candidate.for_faculty(@faculty).finished.should == [@finished]
    end
    it "should return all unready candidates" do
      Candidate.unready.should == [@finished]
    end
    it "should return all ready candidates" do
      Candidate.ready.should == [@ready, @invited, @admitted]
    end
    it "should return all invited candidates" do
      Candidate.invited.should == [@invited, @admitted]
    end
    it "should return all admitted candidates" do
      Candidate.admitted.should == [@admitted]
    end
    it "should return all for specialization" do
      Candidate.for_specialization(@specialization).should == [@specialized, @finished]
    end
  end

  context "Attributes" do
    context "Hierarchy" do
      it "should return faculty from specialization" do
        Candidate.make(:specialization => @specialization).admitting_faculty.should == @faculty
      end
    end
    context "Foreign pay" do
      it "should return if it's foreign payer" do
        Candidate.make(:foreign_pay => false).foreign_pay?.should be_false
        Candidate.make(:foreign_pay => true).foreign_pay?.should be_true
      end
      it "should set foreign payer" do
        candidate = Candidate.make(:foreign_pay => false)
        candidate.foreign_pay!
        candidate.foreign_pay?.should be_true
      end
      it "should unset foreign payer" do
        candidate = Candidate.make(:foreign_pay => true)
        candidate.not_foreign_pay!
        candidate.foreign_pay?.should be_false
      end
    end
    context "Status" do
      it "should set unfinished to delete it from lists" do
        candidate = Candidate.make(:finished)
        candidate.unfinish!
        candidate.should_not be_finished
      end
      it "should be set ready" do
        candidate = Candidate.make(:finished)
        candidate.ready!
        candidate.should be_ready
      end
      it "should be set invited" do
        candidate = Candidate.make(:ready)
        candidate.invite!
        candidate.should be_invited
      end
      it "should be set admitted" do
        candidate = Candidate.make(:invited)
        candidate.admit!
        candidate.should be_admitted
      end
      it "should be set rejected" do
        candidate = Candidate.make(:invited)
        candidate.reject!
        candidate.should be_rejected
      end
      it "should be admited even if rejected" do
        candidate = Candidate.make(:invited)
        candidate.reject!
        candidate.admit_after_reject!
        candidate.should_not be_rejected
        candidate.should be_admitted
      end
      it "should set candidate enrolled" do
        candidate = Candidate.make(:admitted)
        candidate.enroll!(Time.now, false)
        candidate.should be_enrolled
      end
      it "should return it's status" do
        candidate = Candidate.make(:finished)
        candidate.status.should == :not_ready
        candidate.ready!
        candidate.status.should == :ready
        candidate.invite!
        candidate.status.should == :invited
        candidate.admit!
        candidate.status.should == :admitted
        candidate.reject!
        candidate.status.should == :rejected
        candidate.enroll!(Time.now, false)
        candidate.status.should == :enrolled
      end
    end
  end
end

