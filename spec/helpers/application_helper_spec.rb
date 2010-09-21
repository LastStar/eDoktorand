#encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do
  include ApplicationHelper

  it "return translated approver" do
    translate_approver(Dean).should == 'děkan'
  end
end
