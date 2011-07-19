require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CentralRegister::Department do

  context "when parsing correct response" do
    before do
      headers =<<HEADERS
Connection: close
Content-Type: text/xml;charset=UTF-8
Date: Tue, 19 Jul 2011 07:51:59 GMT
Server: Apache-Coyote/1.1
HEADERS
      body =<<BODY
<?xml version='1.0' encoding='UTF-8'?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
  <soapenv:Body>
    <soap:utvaryResponse xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <utvary>
        <utvar>
          <idUtvar>2</idUtvar>
          <nazev_cz>Katedra matematiky</nazev_cz>
          <nazev_en>Department of Mathematics</nazev_en>
          <zkratka>KM</zkratka>
          <kodUtvar>31110</kodUtvar>
          <idFakulta>5</idFakulta>
          <kodFakulta>41310</kodFakulta>
          <idTypUtvar>5</idTypUtvar>
        </utvar>
      </utvary>
    </soap:utvaryResponse>
  </soapenv:Body>
</soapenv:Envelope>
BODY
      Handsoap::Http.drivers[:mock] = Handsoap::Http::Drivers::MockDriver.new :headers => headers.gsub(/\n/, "\r\n"),
                                                                              :content => body,
                                                                              :status => 200
      Handsoap.http_driver = :mock
      Handsoap::Http.drivers[:mock].new
    end
    it "it returns array of department hashes" do
      CentralRegister::Department.all_departments.should == [
        {
          :name => 'Katedra matematiky',
          :name_english => 'Department of Mathematics',
          :short_name => 'KM',
          :code => '31110',
          :faculty_id => '5',
          :faculty_code => '41310',
          :type_id => '5'
        }
      ]
    end
  end
  context "when parsing response with some nil" do
    before do
      headers =<<HEADERS
Connection: close
Content-Type: text/xml;charset=UTF-8
Date: Tue, 19 Jul 2011 07:51:59 GMT
Server: Apache-Coyote/1.1
HEADERS
      body =<<BODY
<?xml version='1.0' encoding='UTF-8'?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
  <soapenv:Body>
    <soap:utvaryResponse xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <utvary>
        <utvar>
          <idUtvar>2</idUtvar>
          <nazev_cz>Katedra matematiky</nazev_cz>
          <nazev_en>Department of Mathematics</nazev_en>
          <zkratka>KM</zkratka>
          <kodUtvar>31110</kodUtvar>
          <idFakulta>5</idFakulta>
          <idTypUtvar>5</idTypUtvar>
        </utvar>
      </utvary>
    </soap:utvaryResponse>
  </soapenv:Body>
</soapenv:Envelope>
BODY
      Handsoap::Http.drivers[:mock] = Handsoap::Http::Drivers::MockDriver.new :headers => headers.gsub(/\n/, "\r\n"),
                                                                              :content => body,
                                                                              :status => 200
      Handsoap.http_driver = :mock
      Handsoap::Http.drivers[:mock].new
    end
    it "what" do
      lambda {CentralRegister::Department.all_departments}.should_not raise_error
    end
  end

end
