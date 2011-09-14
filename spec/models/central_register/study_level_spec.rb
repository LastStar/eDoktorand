require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CentralRegister::StudyForm do

  context "when parsing correct response" do
    before do
      mock_service <<BODY
<soap:enumerationResponse xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <enumeration>
    <item>
      <code>D</code>
      <name>doktorské</name>
      <name_english>doctoral</name_english>
    </item>
    <item>
      <code>M</code>
      <name>magisterské</name>
      <name_english>Master's</name_english>
    </item>
    <item>
      <code>N</code>
      <name>navazující magisterské</name>
      <name_english>post-Bachelor</name_english>
    </item>
  </enumeration>
</soap:enumerationResponse>
BODY
    end
    it "it returns array of marital status hashes" do
      CentralRegister::StudyForm.all.should == [
        {:code => 'D',
        :name => 'doktorské',
        :name_english => 'doctoral',},
        {:code => 'M',
        :name => 'magisterské',
        :name_english => "Master's",
        },
        {:code => 'N',
        :name => 'navazující magisterské',
        :name_english => 'post-Bachelor',
        },
      ]
    end
  end
end


