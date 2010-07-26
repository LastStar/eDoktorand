require 'spec_helper'

describe "/logevents/list" do
  before(:each) do
    @logevent = Logevent.create(:table_key => "id=1",
                                :status => 'N',
                                :event_type => 6,
                                :event_time => '2010/01/01',
                                :perpetrator => "IDM",
                                :table_name => 'im_indices')
    assigns[:logevents] = [@logevent]
    render 'logevents/list'
  end

  #Delete this example and add some real ones or delete this file
  it "should print row with logevent" do
    response.should have_tag('table')
    response.should have_tag('tr#header') do
      with_tag("th.table_key", :text => "table_key")
      with_tag("th.status", :text => "status")
      with_tag("th.event_type", :text => "event_type")
      with_tag("th.event_time", :text => "event_time")
      with_tag("th.perpetrator", :text => "perpetrator")
      with_tag("th.table_name", :text => "table_name")
    end
    response.should have_tag("tr#logevent_#{@logevent.id}") do
      with_tag("td.table_key", :text => "id=1")
      with_tag("td.status", :text => "N")
      with_tag("td.event_type", :text => "6")
      with_tag("td.event_time", :text => "2010-01-01 00:00:00 +0100")
      with_tag("td.perpetrator", :text => "IDM")
      with_tag("td.table_name", :text => "im_indices")
    end
  end
end
