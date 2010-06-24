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
      mocked_user.should_receive(:person).and_return(mocked_faculty_secretary(:faculty => mocked_faculty))
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

  describe "Unsetting foreign payer" do
    before(:each) do
      mocked_user.should_receive(:has_permission?).with("candidates/set_no_foreign_payer").and_return(true)
    end   
    it "should assign candidate by id and set foreign payer on it" do
      Candidate.should_receive(:find).with(1).and_return(mocked_candidate)
      mocked_candidate.should_receive(:not_foreign_pay!).and_return(true)
      get :set_no_foreign_payer, :id => 1
      response.should be_success
    end
  end

  describe "Removing of candidate" do
    before(:each) do
      mocked_user.should_receive(:has_permission?).with("candidates/delete").and_return(true)
    end   
    it "should find candidate by id and call unfinish to hide it from list" do
      Candidate.should_receive(:find).with(1).and_return(mocked_candidate)
      mocked_candidate.should_receive(:unfinish!)
      get :delete, :id => 1
      response.should be_redirect
    end
  end

  describe "Destroying all candidates for faculty" do
    before(:each) do
      mocked_user.should_receive(:has_permission?).with("candidates/destroy_all").and_return(true)
    end   
    it "should assign all candidates from faculty and call destroy on each" do
      mocked_user.should_receive(:person).and_return(mocked_faculty_secretary(:faculty => mocked_faculty))
      Candidate.should_receive(:from_faculty).and_return([mocked_candidate])
      mocked_candidate.should_receive(:destroy)
      get :destroy_all
      response.should be_redirect
    end
  end

  describe "Updating candiddate" do
    before(:each) do
      mocked_user.should_receive(:has_permission?).with("candidates/update").and_return(true)
      @new_attributes = {'id' => 1, 'lastname' => 'Newton'}
    end   
    it "should update candidate from params" do
      Candidate.should_receive(:find).with(1).and_return(mocked_candidate)
      mocked_candidate.should_receive(:update_attributes).with(@new_attributes).and_return(true)
      post :update, :candidate => @new_attributes
      response.should be_redirect
    end
    it "should not update candidate from wrong params" do
      Candidate.should_receive(:find).with(1).and_return(mocked_candidate)
      mocked_candidate.should_receive(:update_attributes).with(@new_attributes).and_return(false)
      post :update, :candidate => @new_attributes
      response.should be_success
    end
  end

  describe "Admit rejected candidate" do
    before(:each) do
      mocked_user.should_receive(:has_permission?).with("candidates/admit_for_revocation").and_return(true)
    end   
    it "should find candidate and admit him after rejection" do
      Candidate.should_receive(:find).with(1).and_return(mocked_candidate)
      mocked_candidate.should_receive(:admit_after_reject!)
      get :admit_for_revocation, :id => 1
      response.should be_redirect
    end
  end

  describe "Admittance form" do
    before(:each) do
      mocked_user.should_receive(:has_permission?).with("candidates/admit").and_return(true)
    end   
    it "should assign candidate" do
      Candidate.should_receive(:find).with(1).and_return(mocked_candidate)
      get :admit, :id => 1
      assigns['candidate'].should == mocked_candidate
      response.should be_success
    end
  end

  describe "Confirmation of admittance" do
    before(:each) do
      mocked_user.should_receive(:has_permission?).with("candidates/confirm_admit").and_return(true)
      @candidate_attributes = {
        "tutor_id" => "1",
        "study_id" => "1",
        "specialization_id" => "1",
        "department_id" => "1"}
    end   
    it "should set all details and admit candidate" do
      Candidate.should_receive(:find).with(1).and_return(mocked_candidate)
      mocked_candidate.should_receive(:update_attributes).with(@candidate_attributes)
      mocked_candidate.should_receive(:admitting_faculty).and_return(mocked_faculty)
      post :confirm_admit, :id => 1, :admit_id => 1, "candidate" => @candidate_attributes
      response.should be_success
      assigns['candidate'].should == mocked_candidate
    end
  end

  describe "Setting candidate as admitted" do
    before(:each) do
      mocked_user.should_receive(:has_permission?).with("candidates/admit_now").and_return(true)
      mocked_faculty_secretary(:email => mocked_email)
      mocked_faculty(:secretary => mocked_faculty_secretary, :short_name => 'fac', :dean => mock(Dean, :display_name => 'Dean'), :dean_label => 'Dean')
      mocked_department(:name => 'Department', :faculty => mocked_faculty)
      mocked_candidate(:department => mocked_department, :email => 'example@example.com', :display_name => 'Candidate', :address => mock(Address), :study => mock(Study, :name => 'study'), :tutor => mock(Tutor, :display_name => 'Tutor'), :present_study? => true)
    end
    it "should set as admitted and send mail if needed" do
      Candidate.should_receive(:find).with(1).and_return(mocked_candidate)
      session[:conditional] = false
      Notifications.should_receive(:admit_candidate).with(mocked_candidate, false).and_return(mock(Object, :deliver => true))
      mocked_candidate.should_receive(:admit!)
      get :admit_now, :id => 1, :mail => 'mail'
      response.should be_success
    end
  end
end
