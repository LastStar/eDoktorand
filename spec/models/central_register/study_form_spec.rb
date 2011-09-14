require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CentralRegister::StudyForm do

  context "when parsing correct response" do
    before do
      mock_service <<BODY
<soap:enumerationResponse xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <enumeration>
    <item>
      <code>D</code>
      <name>prezenční</name>
      <name_english>full-time</name_english>
    </item>
    <item>
      <code>E</code>
      <name>kombinovaná</name>
      <name_english>combined</name_english>
    </item>
    <item>
      <code>X</code>
      <name>jiná</name>
      <name_english>other</name_english>
    </item>
  </enumeration>
</soap:enumerationResponse>
BODY
    end
    it "it returns array of marital status hashes" do
      CentralRegister::StudyForm.all.should == [
        {:code => 'D',
        :name => 'prezenční',
        :name_english => 'full-time',},
        {:code => 'E',
        :name => 'kombinovaná',
        :name_english => 'combined',},
        {:code => 'X',
        :name => 'jiná',
        :name_english => 'other',},
      ]
    end
  end
end


