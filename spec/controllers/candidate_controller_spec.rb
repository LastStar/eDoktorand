require 'spec_helper'

describe CandidatesController do
  describe "List of all candidates" do
    before :each do
      session[:user] = 1
      User.should_receive(:find).twice.and_return(mocked_user)
      mocked_user.should_receive(:has_permission?).with("candidates/list").and_return(true)
    end
    it "should render all candidates for faculty secretary" do
      mocked_faculty_secretary = mock(FacultySecretary, :faculty => mocked_faculty)
      mocked_user.should_receive(:person).twice.and_return(mocked_faculty_secretary)
      mocked_user.should_receive(:has_one_of_roles?).with(['dean', 'faculty_secretary']).and_return(true)
      Candidate.should_receive(:finished).and_return(mocked_relation)
      mocked_relation.should_receive(:for_faculty).with(@mock_faculty).and_return(mocked_relation)
      get :list      
      response.should be_success
    end
  end
end
