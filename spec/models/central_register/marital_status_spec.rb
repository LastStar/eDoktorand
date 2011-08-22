require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CentralRegister::MaritalStatus do

  context "when parsing correct response" do
    before do
      mock_service <<BODY
<soap:enumerationResponse xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <enumeration>
    <item>
      <code>1</code>
      <name>svobodný/á</name>
      <name_english>single</name_english>
    </item>
    <item>
      <code>2</code>
      <name>ženatý,vdaná</name>
      <name_english>married</name_english>
    </item>
  </enumeration>
</soap:enumerationResponse>
BODY
    end
    it "it returns array of marital status hashes" do
      CentralRegister::MaritalStatus.all.should == [
        {
        :code => '1',
        :name => 'svobodný/á',
        :name_english => 'single',
        },
        {
        :code => '2',
        :name => 'ženatý,vdaná',
        :name_english => 'married',
        }
      ]
    end
  end
end


