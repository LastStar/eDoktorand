require 'spec_helper'

describe AccountController do
  describe "Login form" do
    it "should be success" do
      Actuality.should_receive(:find).with(:all, :order => 'id desc').and_return([])
      get :login
      response.should be_success
      response.should render_template 'login'
      assigns[:actualities].should == []
    end
  end

  describe "Successful login" do
    it "should redirect to welcome if authenticated" do
      User.should_receive(:authenticate).with('user', 'passwd').and_return(1)
      post :login, {:user_login => 'user', :user_password => 'passwd'}
      response.should be_redirect
    end
  end

  describe "Failed login" do
    it "should render login form again if not authenticated" do
      User.should_receive(:authenticate).with('user', 'passwd').and_return(nil)
      post :login, {:user_login => 'user', :user_password => 'passwd'}
      response.should render_template 'login'
      assigns[:actualities].should == []
    end
  end

  describe "Logout" do
    it "should redirect to login url" do
      get :logout
      response.should be_redirect
    end
  end

  describe "Welcome" do
    before :each do
      session[:user] = 1
      User.should_receive(:find).twice.and_return(mocked_user)
      mocked_user.should_receive(:has_permission?).with("account/welcome").and_return(true)
    end

    it "should redirect to study plans for student role" do
      mocked_user.should_receive(:has_role?).with('student').and_return(true)
      get :welcome
      response.should be_redirect
      response.should redirect_to(:controller => 'study_plans')
    end

    it "should redirect to students for dean, tutor, department and facutly secretary role" do
      mocked_user.should_receive(:has_role?).with('student').and_return(false)
      mocked_user.should_receive(:has_one_of_roles?).with(['tutor', 'dean', 'department_secretary', 'faculty_secretary']).and_return(true)
      get :welcome
      response.should be_redirect
      response.should redirect_to(:controller => 'students')
    end

    it "should redirect to scholarships for supervisor role" do
      mocked_user.should_receive(:has_role?).with('student').and_return(false)
      mocked_user.should_receive(:has_one_of_roles?).with(['tutor', 'dean', 'department_secretary', 'faculty_secretary']).and_return(false)
      mocked_user.should_receive(:has_role?).with('supervisor').and_return(true)
      get :welcome
      response.should be_redirect
      response.should redirect_to(:controller => 'scholarships', :action => 'list')
    end

    it "should redirect to exams for examinator role" do
      mocked_user.should_receive(:has_role?).with('student').and_return(false)
      mocked_user.should_receive(:has_one_of_roles?).with(['tutor', 'dean', 'department_secretary', 'faculty_secretary']).and_return(false)
      mocked_user.should_receive(:has_role?).with('supervisor').and_return(false)
      mocked_user.should_receive(:has_role?).with('examinator').and_return(true)
      get :welcome
      response.should be_redirect
      response.should redirect_to(:controller => 'exams', :action => 'index')
    end
  end

  describe "Error" do
    it "should render error template" do
      get :error
      response.should be_success
      response.should render_template('account/error')
    end
  end
end
