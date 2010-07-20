require 'spec_helper'

describe IMStudent do
  before(:each) do
    @student = Student.create(:uic => 1,
                              :firstname => 'Josef',
                              :lastname => 'Nosek',
                              :birthname => 'Kosek',
                              :birth_number => '7604242624',
                              :sex => 'M',
                              :title_before => Title.create(:label => 'Ing.', :prefix => true),
                              :title_after => Title.new(:label => 'PhD.', :prefix => false),
                              :birth_place => 'Liberec',
                              :birth_on => '1980-01-01',
                              :citizenship => 'USA',
                              :email => 'example@example.com',
                              :phone => '777666555')
    @im_student = IMStudent.new(:student_id => @student.id)
  end

  it "should have student before saving" do
    @im_student.student = nil
    @im_student.save.should be_false
  end
  it "should be connected to user" do
    @im_student.student.should == @student
  end
  it "should get students attributes" do
    @im_student.save
    @im_student.uic.should == 1
    @im_student.lastname.should == 'Nosek'
    @im_student.firstname.should == 'Josef'
    @im_student.birthname.should == 'Kosek'
    @im_student.birth_number.should == '7604242624'
    @im_student.sex.should == 'M'
    @im_student.created_on.to_i.should == @student.created_on.to_i
    @im_student.title_before.should == 'Ing.'
    @im_student.title_after.should == 'PhD.'
    @im_student.birth_place.should == 'Liberec'
    @im_student.birth_on.should == Date.parse('1980-01-01')
    @im_student.email.should == 'example@example.com'
    @im_student.phone.should == '777666555'
    @im_student.citizenship.should == 'USA'
  end
end
