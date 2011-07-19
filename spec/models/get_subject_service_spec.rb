require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GetSubjectService do
  before do
    @headers = 'Date: Fri, 14 Aug 2009 11:57:36 GMT
      Content-Type: text/xml;charset=UTF-8
      X-Powered-By: Servlet 2.4; JBoss-4.2.2.GA (build: SVNTag=JBoss_4_2_2_GA date=200710221139)/Tomcat-5.5
      Server: Apache-Coyote/1.1'.gsub(/\n/, "\r\n")

  end
  it "parses response and returns subjects hash with all set" do
    body = '<?xml version="1.0" encoding="UTF-8"?>
  <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
    <soap:Body>
      <soap:getSubjectsResponse>
        <subjects>
          <subject id="6825">
            <code>DAAA01Y</code>
            <label>Aplikovana meteorologie a klimatologie</label>
            <labelEn>Applied Meteorology and Climatology</labelEn>
            <idPerson>124</idPerson>
            <depShortcut>KET</depShortcut>
          </subject>
        </subjects>
      </soap:getSubjectsResponse>
    </soap:Body>
  </soap:Envelope>'
    Handsoap::Http.drivers[:mock] = Handsoap::Http::Drivers::MockDriver.new :headers => @headers,
                                                                            :content => body,
                                                                            :status => 200
    Handsoap.http_driver = :mock
    driver = Handsoap::Http.drivers[:mock].new
    result = GetSubjectService.get_subjects
    result.should == [{:code => 'DAAA01Y',
      :label => 'Aplikovana meteorologie a klimatologie',
      :label_en => 'Applied Meteorology and Climatology',
      :department_short_name => 'KET'}]

  end
  it "parses response and returns subjects hash with striped strings" do
    body = '<?xml version="1.0" encoding="UTF-8"?>
  <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
    <soap:Body>
      <soap:getSubjectsResponse>
        <subjects>
          <subject id="6825">
            <code>DAAA01Y  </code>
            <label>Aplikovana meteorologie a klimatologie    </label>
            <labelEn>Applied Meteorology and Climatology     </labelEn>
            <idPerson>124</idPerson>
            <depShortcut>KET</depShortcut>
          </subject>
        </subjects>
      </soap:getSubjectsResponse>
    </soap:Body>
  </soap:Envelope>'
    Handsoap::Http.drivers[:mock] = Handsoap::Http::Drivers::MockDriver.new :headers => @headers,
                                                                            :content => body,
                                                                            :status => 200
    Handsoap.http_driver = :mock
    driver = Handsoap::Http.drivers[:mock].new
    result = GetSubjectService.get_subjects
    result.should == [{:code => 'DAAA01Y',
      :label => 'Aplikovana meteorologie a klimatologie',
      :label_en => 'Applied Meteorology and Climatology',
      :department_short_name => 'KET'}]

  end
  it "parses real response, which should contain errors" do
    body = File.read(File.expand_path(File.dirname(__FILE__) + '/../fixtures/subjects_service_response.xml'))
    Handsoap::Http.drivers[:mock] = Handsoap::Http::Drivers::MockDriver.new :headers => @headers,
                                                                            :content => body,
                                                                            :status => 200
    Handsoap.http_driver = :mock
    driver = Handsoap::Http.drivers[:mock].new
    result = GetSubjectService.get_subjects
  end
end
