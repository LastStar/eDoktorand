require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CentralRegister::Country do

  context "when parsing correct response" do
    before do
      mock_service <<BODY
<soap:enumerationResponse xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <enumeration>
    <item>
      <code>0</code>
      <name>bez státního občanství</name>
      <name_english>without citizenship</name_english>
    </item>
    <item>
      <code>1</code>
      <name>občan</name>
      <name_english>citizen</name_english>
    </item>
    <item>
      <code>2</code>
      <name>uprchlík</name>
      <name_english>refugee</name_english>
    </item>
    <item>
      <code>9</code>
      <name>neznámo, neurčeno</name>
      <name_english>unidentified</name_english>
    </item>
  </enumeration>
</soap:enumerationResponse>
BODY
    end
    it "returns array of education hashes" do
      CentralRegister::Country.all.should == [
        {:code => '0',
        :name => 'bez státního občanství',
        :name_english => 'without citizenship',},
        {:code => '1',
        :name => 'občan',
        :name_english => 'citizen',},
        {:code => '2',
        :name => 'uprchlík',
        :name_english => 'refugee',},
        {:code => '9',
        :name => 'neznámo, neurčeno',
        :name_english => 'unidentified',},
      ]
    end
  end
end


