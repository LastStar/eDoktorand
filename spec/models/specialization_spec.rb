require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe Specialization do
  context "Length of study" do
    it "should have lenght of study in years like attribute" do
      c = Specialization.new(:study_length => 2)
      c.study_length.should == 2
    end

    it "should return 3 when nothing is set" do
      c = Specialization.new
      c.study_length.should == 3
    end

    it "returns last possible semmester for exam" do
      c = Specialization.new
      c.last_possible_exam_semester.should == 4
      c.study_length = 4
      c.last_possible_exam_semester.should == 6
    end

    it "returns last possible semmester for defense" do
      c = Specialization.new
      c.last_possible_defense_semester.should == 6
      c.study_length = 4
      c.last_possible_defense_semester.should == 8
    end
  end
end
