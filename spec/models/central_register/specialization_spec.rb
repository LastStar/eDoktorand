require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CentralRegister::Specialization do

  context "when parsing correct response" do
    before do
      mock_service <<BODY
<soap:oboryResponse xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <oboryList>
    <specialization>
      <id>128</id>
      <nameCz>Ochrana lesů a myslivost</nameCz>
      <nameEn>Forest Protection and Game Management</nameEn>
      <shortName>XOCHMY</shortName>
      <msmtCode>4107V013</msmtCode>
      <faculty>41410</faculty>
      <language>CZE</language>
      <qualificationCode>D</qualificationCode>
      <qualificationCz>doktorské</qualificationCz>
      <qualificationEn>doctoral</qualificationEn>
      <studyFormCz>prezenční</studyFormCz>
      <studyFormEn>full-time</studyFormEn>
      <acreditedFrom/>
      <acreditedTill/>
      <grantorUIC>0</grantorUIC>
    </specialization>
    <specialization>
      <id>115</id>
      <nameCz>Výživa a ochrana rostlin</nameCz>
      <nameEn>Plant Nutrition and Protection</nameEn>
      <shortName>AMRV</shortName>
      <msmtCode>4102T017</msmtCode>
      <faculty>41210</faculty>
      <language>CZE</language>
      <qualificationCode>N</qualificationCode>
      <qualificationCz>navazující magisterské</qualificationCz>
      <qualificationEn>Master's (post-Bachelor)</qualificationEn>
      <studyFormCz>prezenční</studyFormCz>
      <studyFormEn>full-time</studyFormEn>
      <acreditedFrom>10.04.2006</acreditedFrom>
      <acreditedTill>01.12.2015</acreditedTill>
      <grantorUIC>53288</grantorUIC>
    </specialization>
  </oboryList>
</soap:oboryResponse>

BODY
    end

    it "returns array of specialization hashes" do
      CentralRegister::Specialization.all.should == [
        {
          :msmtCode => '4107V013',
          :shortName => "XOCHMY",
          :nameCz => 'Ochrana lesů a myslivost',
          :nameEn => 'Forest Protection and Game Management',
          :language => "CZE"
        }
      ]
    end
  end

end
