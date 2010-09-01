require 'spec_helper'

describe ImIndex do
  it 'exists in system' do
    ImIdentity.new
  end

  before(:each) do
    @student = Factory(:student, :uic => 111222)
    @identity = ImIdentity.create(:uic => @student.uic, :loginname => 'student')
  end

  it "has it's student" do
    @identity.student.uic.should == @student.uic
  end

  it "creates user for its student" do
    @identity.update_user
    @student.user.login.should == 'student'
  end
  
  it "updates existing student user" do
    @student.user = Factory(:user, :person => @student)
    @identity.update_user
    @student.reload
    @student.user.login.should == 'student'
  end
end
