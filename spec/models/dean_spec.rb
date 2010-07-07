require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Dean do
  it "should return it's faculty" do
    @deanship = Deanship.make
    @dean = Dean.make(:deanship => @deanship)
    @dean.faculty.should == @deanship.faculty
  end
  it "should return if it's index dean" do
    @index = Index.make
    @other_index = Index.make
    @deanship = Deanship.make(:faculty => @index.faculty)
    @dean = Dean.make(:deanship => @deanship)
    @dean.should be_dean_of(@index)
    @dean.should_not be_dean_of(@other_index)
  end
end

