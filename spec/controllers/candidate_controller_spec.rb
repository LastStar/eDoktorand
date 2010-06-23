require 'spec_helper'

describe CandidatesController do
  before :each do
    session[:user] = 1
    User.should_receive(:find).twice.and_return(mocked_user)
  end
  describe "List of all candidates" do
    before :each do
      mocked_user.should_receive(:has_permission?).with("candidates/list").and_return(true)
    end
    it "should render all faculty candidates for faculty secretary" do
      mocked_user.should_receive(:person).and_return(mocked_faculty_secretary)
      mocked_user.should_receive(:has_one_of_roles?).with(['dean', 'faculty_secretary', 'department_secretary']).and_return(true)
      Candidate.should_receive(:finished).and_return(mocked_relation)
      mocked_relation.should_receive(:for_faculty).with(@mock_faculty).and_return(mocked_relation)
      mocked_relation.should_receive(:order).with('lastname').and_return(mocked_relation)
      get :list      
      response.should be_success
      assigns['candidates'].should == mocked_relation
    end
    it "should render all candidates for vicerector" do
      mocked_user.should_receive(:has_one_of_roles?).with(['dean', 'faculty_secretary', 'department_secretary']).and_return(false)
      Candidate.should_receive(:finished).and_return(mocked_relation)
      mocked_relation.should_receive(:order).with('lastname').and_return(mocked_relation)
      get :list      
      response.should be_success
      assigns['candidates'].should == mocked_relation
    end
  end

  describe "Candidate detail" do
    before(:each) do
      mocked_user.should_receive(:has_permission?).with("candidates/show").and_return(true)
    end   
    it "should allow to see candidate detail and assign candidate by id" do
      Candidate.should_receive(:find).with(1).and_return(mocked_candidate)
      get :show, :id => 1
      response.should be_success
      assigns['candidate'].should == mocked_candidate
    end
  end

  describe "Edit candidate" do
    before(:each) do
      mocked_user.should_receive(:has_permission?).with("candidates/edit").and_return(true)
    end   
    it "should allow edit candidate and assign candidate by id" do
      Candidate.should_receive(:find).with(1).and_return(mocked_candidate)
      get :edit, :id => 1
      response.should be_success
      assigns['candidate'].should == mocked_candidate
    end
  end

  describe "Setting foreign payer" do
    before(:each) do
      mocked_user.should_receive(:has_permission?).with("candidates/set_foreign_payer").and_return(true)
    end   
    it "should assign candidate by id and set foreign payer on it" do
      Candidate.should_receive(:find).with(1).and_return(mocked_candidate)
      mocked_candidate.should_receive(:foreign_pay!).and_return(true)
      get :set_foreign_payer, :id => 1
    end
  end

  describe "Setting foreign payer" do
    before(:each) do
      mocked_user.should_receive(:has_permission?).with("candidates/set_no_foreign_payer").and_return(true)
    end   
    it "should assign candidate by id and set foreign payer on it" do
      Candidate.should_receive(:find).with(1).and_return(mocked_candidate)
      mocked_candidate.should_receive(:not_foreign_pay!).and_return(true)
      get :set_no_foreign_payer, :id => 1
    end
  end
end
