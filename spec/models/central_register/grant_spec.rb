require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CentralRegister::Grant do

  context "when parsing correct response" do
    before do
      mock_service <<BODY
<soap:grantsResponse xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <grants>
    <grant>
      <id>1</id>
      <guarantee_uic>64816</guarantee_uic>
      <name>Simulační modely ověřování účinnosti nástrojů zemědělské politiky</name>
      <name_english>Simulation models of agricultural policy instruments</name_english>
      <finance>257000</finance>
      <year_from>2003</year_from>
      <year_to>2004</year_to>
      <provider_code>GA0</provider_code>
      <provider_name>Grantová agentura ČR</provider_name>
    </grant>
    <grant>
      <id>2</id>
      <guarantee_uic>51852</guarantee_uic>
      <name>Analýza externalit v procesu globalizace s aplikací na agrární sektor České republiky</name>
      <name_english>The Analysis of Externalities under the Proces of Globalization -Aplication in Agrarian Proces</name_english>
      <finance>720000</finance>
      <year_from>2004</year_from>
      <year_to>2006</year_to>
      <provider_code>GA0</provider_code>
      <provider_name>Grantová agentura ČR</provider_name>
    </grant>
  </grants>
</soap:grantsResponse>
BODY
    end
    it "it returns array of grants hashes" do
      CentralRegister::Grant.all.should == [
        {
        :guarantee_uic => '64816',
        :name => 'Simulační modely ověřování účinnosti nástrojů zemědělské politiky',
        :name_english => 'Simulation models of agricultural policy instruments',
        :finance => '257000',
        :year_from => '2003',
        :year_to => '2004',
        :provider_code => 'GA0',
        :provider_name => 'Grantová agentura ČR',
        },
        {
        :guarantee_uic => '51852',
        :name => 'Analýza externalit v procesu globalizace s aplikací na agrární sektor České republiky',
        :name_english => 'The Analysis of Externalities under the Proces of Globalization -Aplication in Agrarian Proces',
        :finance => '720000',
        :year_from => '2004',
        :year_to => '2006',
        :provider_code => 'GA0',
        :provider_name => 'Grantová agentura ČR',
        }
      ]
    end
  end
end





