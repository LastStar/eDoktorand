require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Logevent do
  it "should be created when ImStudent created" do
    @student = Student.make
    @logevent = Logevent.last
    @logevent.should_not be_nil
    @logevent.table_key.should == "id=#{@student.im_student.id}"
    @logevent.status.should == 'N'
    @logevent.event_type.should == 5
    @logevent.event_time.should_not be_nil
    @logevent.event_time.should <= Time.now
    @logevent.perpetrator.should == "IDM"
    @logevent.table_name.should == "im_students"
  end
  it "should be created when ImIndex created" do
    @student = Student.make
    @index = Index.make(:student => @student)
    @logevent = Logevent.last
    @logevent.should_not be_nil
    @logevent.table_key.should == "id=#{@index.im_index.id}"
    @logevent.status.should == 'N'
    @logevent.event_type.should == 5
    @logevent.event_time.should_not be_nil
    @logevent.event_time.should <= Time.now
    @logevent.perpetrator.should == "IDM"
    @logevent.table_name.should == "im_indices"
  end
  it "should be created when ImStudent updated" do
    @student = Student.make
    @student.update_attribute(:lastname, 'Kosek')
    @logevent = Logevent.last
    @logevent.should_not be_nil
    @logevent.table_key.should == "id=#{@student.im_student.id}"
    @logevent.status.should == 'N'
    @logevent.event_type.should == 6
    @logevent.event_time.should_not be_nil
    @logevent.event_time.should <= Time.now
    @logevent.perpetrator.should == "IDM"
    @logevent.table_name.should == "im_students"
  end
  it "should be created when ImIndex created" do
    @student = Student.make
    @index = Index.make(:student => @student)
    @index.update_attribute(:payment_id, 2)
    @logevent = Logevent.last
    @logevent.should_not be_nil
    @logevent.table_key.should == "id=#{@index.im_index.id}"
    @logevent.status.should == 'N'
    @logevent.event_type.should == 6
    @logevent.event_time.should_not be_nil
    @logevent.event_time.should <= Time.now
    @logevent.perpetrator.should == "IDM"
    @logevent.table_name.should == "im_indices"
  end
end
