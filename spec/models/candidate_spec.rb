require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Candidate do
  #TODO test foreign candidates
  it 'enrolls and return new student with index' do
    mock_uic_getter = mock(UicGetter)
    UicGetter.should_receive(:new).and_return(mock_uic_getter)
    mock_uic_getter.should_receive(:get_uic).with('7604242624').and_return(1)
    candidate = Factory(:candidate, :postal_street => 'Short')
    candidate.tutor = Factory(:tutor)
    candidate.specialization = Factory(:specialization)
    candidate.study = Factory(:study)
    student = candidate.enroll!('2010-07-12', '2010-10-01')
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
    student.index.enrolled_on.should == Time.parse('2010-07-12')
    student.index.study_start_on.should == Date.parse('2010-10-01')
    student.index.tutor.should == candidate.tutor
    student.index.payment_id.should == 1
    candidate.student.should == student
  end

  it "strips all spaces from birth number" do
    candidate = Factory.build(:candidate, :birth_number => '7604242624 ')
    candidate.save
    candidate.reload
    candidate.birth_number.should == '7604242624'
  end

  it "toggles foreign payment" do
    candidate = Factory(:candidate)
    candidate.toggle_foreign_pay
    candidate.should be_foreign_pay
    candidate.toggle_foreign_pay
    candidate.should_not be_foreign_pay
  end

  it "has admittance theme" do
    candidate = Factory(:candidate)
    admittance_theme = AdmittanceTheme.new
    candidate.admittance_theme = admittance_theme
    candidate.admittance_theme.should == admittance_theme
  end

  it 'is not valid when department is from other department' do
    candidate = Factory(:candidate)
    candidate.admittance_theme = AdmittanceTheme.new(:department => Factory(:department))
    candidate.should_not be_valid
  end

  it 'is not valid when does not have admittance theme and some exists for its specialization' do
    candidate = Factory(:candidate)
    candidate.specialization = Factory(:specialization)
    AdmittanceTheme.create(:name => 'some name', :specialization => candidate.specialization)
    candidate.should_not be_valid
  end

end

