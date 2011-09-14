require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CentralRegister::Education do

  context "when parsing correct response" do
    before do
      mock_service <<BODY
<soap:enumerationResponse xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <enumeration>
    <item>
      <code>K</code>
      <name>SŠ s maturitou</name>
      <name_english>SecS with leaving exam</name_english>
    </item>
    <item>
      <code>L</code>
      <name>SOŠ s maturitou i s vyučením</name>
      <name_english>SecS with leaving exam and vocat.cert.</name_english>
    </item>
  </enumeration>
</soap:enumerationResponse>
BODY
    end
    it "it returns array of education hashes" do
      CentralRegister::Education.all.should == [
        {:code => 'K',
        :name => 'SŠ s maturitou',
        :name_english => 'SecS with leaving exam',},
        {:code => 'L',
        :name => 'SOŠ s maturitou i s vyučením',
        :name_english => 'SecS with leaving exam and vocat.cert.',},
      ]
    end
  end
end


