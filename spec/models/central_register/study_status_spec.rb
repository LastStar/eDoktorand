require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CentralRegister::StudyStatus do

  context "when parsing correct response" do
    before do
      mock_service <<BODY
<soap:enumerationResponse xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <enumeration>
    <item>
      <code>A</code>
      <name>absolvoval</name>
      <name_english>graduated</name_english>
    </item>
    <item>
      <code>D</code>
      <name>podmíněný zápis</name>
      <name_english>conditionally enrolled</name_english>
    </item>
    <item>
      <code>O</code>
      <name>opakuje</name>
      <name_english>repeating</name_english>
    </item>
  </enumeration>
</soap:enumerationResponse>
BODY
    end
    it "it returns array of marital status hashes" do
      CentralRegister::StudyStatus.all.should == [
        {:code => 'A',
        :name => 'absolvoval',
        :name_english => 'graduated',},
        {:code => 'D',
        :name => 'podmíněný zápis',
        :name_english => 'conditionally enrolled',},
        {:code => 'O',
        :name => 'opakuje',
        :name_english => 'repeating',},
      ]
    end
  end
end


