require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Address" do
  context "Printing" do
    it "should print address in one line" do
      address = Factory(:address)
      address.to_line_s.should == "Street 8, City, 11111"
    end
  end

  context "Preparing habitat" do
    it "should build habitat for student" do
      student = Factory(:student)
      address = Address.new_habitat_for(student)
      address.should be_new_record
      address.student.should == student
    end
    it "should create habitat for student" do
      student = Factory(:student)
      address = Address.create_habitat_for(student)
      address.should_not be_new_record
      address.student.should == student
    end
  end
end
