require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CentralRegister::Department do

  context "when parsing correct response" do
    before do
      mock_service <<BODY
<?xml version='1.0' encoding='UTF-8'?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
  <soapenv:Body>
    <soap:utvaryResponse xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <departments>
        <department>
          <id>2</id>
          <name>Katedra matematiky</name>
          <name_english>Department of Mathematics</name_english>
          <short_name>KM</short_name>
          <code>31110</code>
          <faculty_id>5</faculty_id>
          <faculty_code>41310</faculty_code>
          <department_type_id>1</department_type_id>
        </department>
        <department>
          <id>3</id>
          <name>Katedra fyziky</name>
          <name_english>Department of Physics</name_english>
          <short_name>KF</short_name>
          <code>31120</code>
          <faculty_id>5</faculty_id>
          <faculty_code>41310</faculty_code>
          <department_type_id>1</department_type_id>
        </department>
      </departments>
    </soap:utvaryResponse>
  </soapenv:Body>
</soapenv:Envelope>
BODY
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
          :department_type_id => '1'
        },
        {
          :name => 'Katedra fyziky',
          :name_english => 'Department of Physics',
          :short_name => 'KF',
          :code => '31120',
          :faculty_id => '5',
          :faculty_code => '41310',
          :department_type_id => '1'
        }
      ]
    end
  end
  context "when parsing response with some nil" do
    before do
      mock_service <<BODY
<?xml version='1.0' encoding='UTF-8'?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
  <soapenv:Body>
    <soap:utvaryResponse xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <departments>
        <department>
          <id>3</id>
          <name>Katedra fyziky</name>
          <name_english>Department of Physics</name_english>
          <short_name>KF</short_name>
          <code>31120</code>
          <faculty_id>5</faculty_id>
          <faculty_code>41310</faculty_code>
          <department_type_id>1</department_type_id>
        </department>
      </departments>
    </soap:utvaryResponse>
  </soapenv:Body>
</soapenv:Envelope>
BODY
    end
    it "should not raise error" do
      lambda {CentralRegister::Department.all_departments}.should_not raise_error
    end
  end

end
