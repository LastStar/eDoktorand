require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdmittanceTheme do
  let(:admittance_theme) {AdmittanceTheme.new}
  let(:specialization) {Factory(:specialization)}
  let(:tutor) {Factory(:tutor)}
  let(:department) {Factory(:department)}
  it 'can be created with valid attributes' do
    admittance_theme.name = 'some name'
    admittance_theme.save.should be_true
  end
  it 'has one specialization' do
    admittance_theme.specialization = specialization
    admittance_theme.specialization.should == specialization
  end
  it 'has one department' do
    admittance_theme.department = department
    admittance_theme.department.should == department
  end
  context 'with tutor' do
    it 'has one tutor' do
      admittance_theme.tutor = tutor
      admittance_theme.tutor.should == tutor
    end
    it 'returns formated name with tutor display name' do
      admittance_theme.tutor = tutor
      admittance_theme.name = 'some name'
      admittance_theme.display_name.should == "some name (#{tutor.display_name})"
    end
  end
  context 'with specialization' do
    it 'should return if specialization have any admittance themes' do
      admittance_theme.specialization = specialization
      admittance_theme.name = 'Some name'
      admittance_theme.save
      AdmittanceTheme.has_for?(specialization).should be_true
    end
    it 'returns possible departments for specializations' do
      admittance_theme.specialization = specialization
      admittance_theme.department = department
      admittance_theme.name = 'Some name'
      admittance_theme.save
      AdmittanceTheme.create(:specialization => specialization, :department => department, :name => 'some name')
      AdmittanceTheme.departments_for_specialization(specialization).should =~ [department]
    end
  end
end
