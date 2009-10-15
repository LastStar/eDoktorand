require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe Coridor do
  it "should have lenght of study in years like attribute" do
    c = Coridor.new
    c.study_length = 2
    c.study_length.should == 2
  end

  it "should return 3 when nothing is set" do
    c = Coridor.new
    c.study_length.should == 3
  end
end