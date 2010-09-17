require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ImIdentity do
  before(:each) do
    @student = Student.make(:uic => 111222)
    @identity = ImIdentity.create(:uic => @student.uic,
                                  :loginname => 'student',
                                  :status => 'N')
    @role = Role.create(:name => 'student')
  end

  context "update user"do
    it "has it's student" do
      @identity.student.uic.should == @student.uic
    end
    it "creates user for its student" do
      @identity.update_user
      @student.user.login.should == 'student'
      @student.user.roles.include?(@role).should be_true
    end
    it "updates existing student user" do
      @student.user = User.make(:person => @student)
      @identity.update_user
      @student.reload
      @student.user.login.should == 'student'
      @student.user.roles.include?(@role).should be_true
      @student.user.roles.size.should == 1
    end
    it "sets its status to S if it worked" do
      @identity.update_user
      @identity.status.should == 'S'
    end
  end

  context "scoped" do
    it "find all not processed identities" do
      ImIdentity.to_process.should == [@identity]
      @identity.update_user
      ImIdentity.to_process.should == []
    end
  end

  context 'processing' do
    it "finds all not processed identities and update user" do
      ImIdentity.process_unprocessed
      ImIdentity.to_process.should == []
    end
  end
end
