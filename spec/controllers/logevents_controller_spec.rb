require 'spec_helper'

describe LogeventsController do


  describe "GET 'list'" do
    it "should be successful" do
      Logevent.should_receive(:all).and_return([])
      get 'list'
      assigns[:logevents].should_not be_nil
      assigns[:logevents].should == []
      response.should be_success
    end
  end
end
