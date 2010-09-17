require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Student do
  before(:each) do
    @student = Student.make
  end
  it "should prepare ImStudent" do
    @student.prepare_im_student
    @student.im_student.should_not be_nil
  end
  it "should prepare its ImStudent when created" do
    @student.save
    @student.im_student.should_not be_nil
  end
  it "should copy attributes to ImStudent when saved" do
    @student.save
    @student.im_student.lastname.should == 'Block'
    @student.update_attribute(:lastname, 'Kosek')
    @student.im_student.lastname.should == 'Kosek'
  end
end
