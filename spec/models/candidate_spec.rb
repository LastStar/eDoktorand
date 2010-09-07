require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Index do
  #TODO test foreign candidates
  it 'enrolls a return new student with index' do
    mock_uic_getter = mock(UicGetter)
    UicGetter.should_receive(:new).and_return(mock_uic_getter)
    mock_uic_getter.should_receive(:get_uic).with('7604242624').and_return(1)
    candidate = Factory(:candidate, :postal_street => 'Short')
    candidate.tutor = Factory(:tutor)
    candidate.specialization = Factory(:specialization)
    candidate.study = Factory(:study)
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
    student.index.enrolled_on.should == Time.parse('2010-01-01')
    student.index.tutor.should == candidate.tutor
    student.index.payment_id.should == 1
    candidate.student.should == student
  end
end

