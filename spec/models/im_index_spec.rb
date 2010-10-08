require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ImIndex do
  before(:each) do
    Timecop.freeze('2010-01-01')
  end

  it "should have index before creating" do
    im_index = ImIndex.new
    im_index.save.should be_false
  end
  it "should be connected to index" do
    index = Factory(:index, :student => Student.new(:lastname => "Josef", :firstname => "Nosek"))
    im_index = ImIndex.new(:index => index)
    im_index.index.should == index
  end
  it "should copy attributes from index" do
    index = Factory(:index, :student => Student.new(:uic => 1, :sident => 2, :lastname => "Josef", :firstname => "Nosek"))
    im_index = ImIndex.create(:index => index)
    im_index.student_uic.should == 1
    im_index.department_name.should == "department"
    im_index.department_code.should == "DEP"
    im_index.faculty_name.should == "faculty"
    im_index.faculty_code.should == "FAC"
    im_index.study_year.should == 1
    im_index.academic_year.should == '2009/2010'
    im_index.study_type.should == 'doktorský'
    im_index.study_type_code.should == 'D'
    im_index.study_form.should == 'prezenční'
    im_index.study_form_code.should == 'D'
    im_index.study_spec.should == 'specialization'
    im_index.study_spec_code.should == 'SPE'
    im_index.study_spec_msmt_code.should == 'MSPE'
    im_index.study_prog.should == 'program'
    im_index.study_prog_code.should == 'PRG'
    im_index.study_status.should == 'studuje'
    im_index.study_status_code.should == 'S'
    im_index.study_status_from.should == Date.parse('2009/09/30')
    im_index.study_status_to.should == Date.parse('2010/09/30')
    im_index.enrollment_date.should == Date.parse('2009/09/30')
    im_index.financing_type_code.should == 1
    im_index.financing_type.should == 'studium ve standardní době studia'
    im_index.education_language.should == 'český jazyk'
    im_index.education_language_code.should == 'CZ'
    im_index.education_place.should == 'Praha'
    im_index.study_form_changed_on.should == Date.parse('2010-01-02')
    im_index.sident.should == 2
  end
  it "should get other study statuses" do
    pending
  end
  it "should get other financing types" do
    pending
  end


end
