require 'spec_helper'

describe Student do
  before(:each) do
    @student = Student.new(:firstname => 'Josef',
                              :lastname => 'Nosek')
  end
  it "prepares ImStudent" do
    @student.prepare_im_student
    @student.im_student.should_not be_nil
  end
  it "updates ImStudent" do
    @student.prepare_im_student
    @student.update_im_student
    @student.im_student.lastname.should == 'Nosek'
    @student.update_attribute(:lastname, 'Kosek')
    @student.update_im_student
    @student.im_student.lastname.should == 'Kosek'
  end
end
