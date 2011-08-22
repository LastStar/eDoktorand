require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CentralRegister::MaritalStatus do

  context "when parsing correct response" do
    before do
      mock_service <<BODY
<soap:enumerationResponse xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <enumeration>
    <item>
      <code>1</code>
      <name>muž</name>
      <name_english>male</name_english>
    </item>
    <item>
      <code>2</code>
      <name>žena</name>
      <name_english>female</name_english>
    </item>
  </enumeration>
</soap:enumerationResponse>
BODY
    end
    it "it returns array of gender hashes" do
      CentralRegister::Gender.all.should == [
        {:code => '1',
        :name => 'muž',
        :name_english => 'male',
        },
        {:code => '2',
        :name => 'žena',
        :name_english => 'female',
        }
      ]
    end
  end
end


