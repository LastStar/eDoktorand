require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CentralRegister::Subject do

  context "when parsing correct response" do
    before do
      mock_service <<BODY
<soap:getSubjectsResponse xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
<subjects>
  <subject>
    <code>DACA02Y</code>
    <label>Speciální biochemie rostlin</label>
    <labelEn>Special Plant Biochemistry</labelEn>
    <uic>51219</uic>
    <department>21120</department>
  </subject>
  <subject>
    <code>DACA04Y</code>
    <label>Chemie přírodních látek</label>
    <labelEn>Chemistry of Natural Compounds</labelEn>
    <uic>51219</uic>
    <department>21120</department>
  </subject>
</subjects>
</soap:getSubjectsResponse>
BODY
    end
    it "returns array of subject's hashes" do
      CentralRegister::Subject.all.should == [
        {
        :code => 'DACA02Y',
        :label => 'Speciální biochemie rostlin',
        :labelEn => 'Special Plant Biochemistry',
        :uic => '51219',
        :department => '21120'
      },
        {
        :code => 'DACA04Y',
        :label => 'Chemie přírodních látek',
        :labelEn => 'Chemistry of Natural Compounds',
        :uic => '51219',
        :department => '21120'
      }]
    end
  end
end
