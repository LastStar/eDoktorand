require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GetSubjectService do
  it "parses response and returns subjects hash with all set" do
    mock_service <<BODY
<?xml version="1.0" encoding="UTF-8"?>
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
</soap:Envelope>
BODY
    result = GetSubjectService.get_subjects
    result.should == [{:code => 'DAAA01Y',
      :label => 'Aplikovana meteorologie a klimatologie',
      :label_en => 'Applied Meteorology and Climatology',
      :department_short_name => 'KET'}]

  end
  it "parses response and returns subjects hash with striped strings" do
    mock_service <<BODY
<?xml version="1.0" encoding="UTF-8"?>
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
</soap:Envelope>
BODY
    result = GetSubjectService.get_subjects
    result.should == [{:code => 'DAAA01Y',
      :label => 'Aplikovana meteorologie a klimatologie',
      :label_en => 'Applied Meteorology and Climatology',
      :department_short_name => 'KET'}]

  end
  it "parses real response, which could contain errors" do
    mock_service File.read(File.expand_path(File.dirname(__FILE__) + '/../fixtures/subjects_service_response.xml'))
    result = GetSubjectService.get_subjects
  end
end
