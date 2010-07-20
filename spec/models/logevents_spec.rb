require 'spec_helper'

describe Logevents do
  before(:each) do
    @valid_attributes = {
      :table_key => "value for table_key",
      :status => "value for status",
      :event_type => 1,
      :event_time => Time.now,
      :perpetrator => "value for perpetrator",
      :table_name => "value for table_name"
    }
  end

  it "should create a new instance given valid attributes" do
    Logevents.create!(@valid_attributes)
  end
end
