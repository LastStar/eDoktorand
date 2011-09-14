require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CentralRegister::Faculty do

  context "when parsing correct response" do
    before do
      mock_service <<BODY
<soap:facultyResponse xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <faculties>
    <faculty>
      <id>1</id>
      <name>Fakulta agrobiologie, potravinových a přírodních zdrojů</name>
      <name_english>Faculty of Agrobiology, Food and Natural Resources</name_english>
      <short_name>FAPPZ</short_name>
      <code>41210</code>
      <ldap_context>OU=AF,O=CZU,C=CZ</ldap_context>
    </faculty>
  </faculties>
</soap:facultyResponse>
BODY
    end
    it "it returns array of faculties hashes" do
      CentralRegister::Faculty.all.should == [
        {:name => 'Fakulta agrobiologie, potravinových a přírodních zdrojů',
        :name_english => 'Faculty of Agrobiology, Food and Natural Resources',
        :short_name => 'FAPPZ',
        :code => '41210',
        :ldap_context => 'OU=AF,O=CZU,C=CZ',},
      ]
    end
  end
end
