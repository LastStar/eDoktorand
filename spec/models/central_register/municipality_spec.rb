require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CentralRegister::Municipality do

  context "when parsing correct response" do
    before do
      mock_service <<BODY
<soap:enumerationResponse xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <enumeration>
    <item>
      <code>500011</code>
      <name>Želechovice nad Dřevnicí</name>
      <name_english/>
    </item>
    <item>
      <code>500259</code>
      <name>Veřovice</name>
      <name_english/>
    </item>
    <item>
      <code>500291</code>
      <name>Vřesina</name>
      <name_english/>
    </item>
  </enumeration>
</soap:enumerationResponse>
BODY
    end
    it "it returns array of marital status hashes" do
      CentralRegister::Municipality.all.should == [
        {:code => '500011',
        :name => 'Želechovice nad Dřevnicí',},
        {:code => '500259',
        :name => 'Veřovice',},
        {:code => '500291',
        :name => 'Vřesina',},
      ]
    end
  end
end


