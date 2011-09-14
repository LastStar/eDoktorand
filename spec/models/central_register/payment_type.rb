require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CentralRegister::PaymentType do

  context "when parsing correct response" do
    before do
      mock_service <<BODY
<soap:enumerationResponse xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <enumeration>
    <item>
      <code>1</code>
      <name>01-studium ve standardní době studia</name>
    </item>
    <item>
      <code>10</code>
      <name>10-školné na soukromých vysokých školách</name>
    </item>
    <item>
  </enumeration>
</soap:enumerationResponse>
BODY
    end
    it "it returns array of payment types hashes" do
      CentralRegister::PaymentType.all.should == [
        {:code => '1',
        :name => '01-studium ve standardní době studia',},
        {:code => '10',
        :name => '10-školné na soukromých vysokých školách',},
      ]
    end
  end
end


