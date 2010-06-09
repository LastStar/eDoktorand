require 'spec_helper'

describe FormController do
  describe "Index page" do
    it "should render index page" do
      Faculty.should_receive(:find).with(:all).and_return([])
      get :index
      response.should be_success
      response.should render_template 'index'
      assigns['faculties'].should == []
    end
  end

  describe "Details form" do
    before :each do
      specialization = mock(Specialization, :id => 1, :name => 'spec')
      @candidate = mock(Candidate, :specialization => specialization)
      Candidate.should_receive(:new).and_return(@candidate)
    end
    it "should render details form" do
      get :details, :id => 1
      response.should be_success
      response.should render_template 'details'
      assigns['candidate'].should == @candidate
    end
  end
end
