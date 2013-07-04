require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CentralRegister::Country do

  context "when parsing correct response" do
    before do
      mock_service <<BODY
<soap:enumerationResponse xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <enumeration>
    <item>
      <code>10000</code>
      <name>Praha 10</name>
      <name_english></name_english>
    </item>
    <item>
      <code>10001</code>
      <name>Praha 100</name>
      <name_english></name_english>
    </item>
    <item>
      <code>10003</code>
      <name>Depo Praha 701</name>
      <name_english></name_english>
    </item>
    <item>
      <code>10004</code>
      <name>Praha 104</name>
      <name_english></name_english>
    </item>
    <item>
      <code>10005</code>
      <name>Praha 105</name>
      <name_english></name_english>
    </item>
    <item>
      <code>10007</code>
      <name>Praha 107</name>
      <name_english></name_english>
    </item>
    <item>
      <code>10010</code>
      <name>Praha 110</name>
      <name_english></name_english>
    </item>
    <item>
      <code>10100</code>
      <name>Praha 101</name>
      <name_english></name_english>
    </item>
    <item>
      <code>10200</code>
      <name>Praha 102</name>
      <name_english></name_english>
    </item>
    <item>
      <code>10300</code>
      <name>Praha 113</name>
      <name_english></name_english>
    </item>
    <item>
      <code>10400</code>
      <name>Praha 114</name>
      <name_english></name_english>
    </item>
    <item>
      <code>10600</code>
      <name>Praha 106</name>
      <name_english></name_english>
    </item>
    <item>
      <code>10700</code>
      <name>Praha 112</name>
      <name_english></name_english>
    </item>
    <item>
      <code>10800</code>
      <name>Praha 108</name>
      <name_english></name_english>
    </item>
    <item>
      <code>10900</code>
      <name>Praha 111</name>
      <name_english></name_english>
    </item>
    <item>
      <code>11000</code>
      <name>Praha 1</name>
      <name_english></name_english>
    </item>
    <item>
      <code>11001</code>
      <name>Praha 01</name>
      <name_english></name_english>
    </item>
    <item>
      <code>11002</code>
      <name>Praha 02</name>
      <name_english></name_english>
    </item>
    <item>
      <code>11004</code>
      <name>Praha 04</name>
      <name_english></name_english>
    </item>
  </enumeration>
  </soap:enumerationResponse>
BODY
      end

    it "it returns array of education hashes" do
      CentralRegister::Zip.all.should == [
        { :code => "10000", :name => "Praha 10" },
        { :code => "10001", :name => "Praha 100" },
        { :code => "10003", :name => "Depo Praha 701" },
        { :code => "10004", :name => "Praha 104" },
        { :code => "10005", :name => "Praha 105" },
        { :code => "10007", :name => "Praha 107" },
        { :code => "10010", :name => "Praha 110" },
        { :code => "10100", :name => "Praha 101" },
        { :code => "10200", :name => "Praha 102" },
        { :code => "10300", :name => "Praha 113" },
        { :code => "10400", :name => "Praha 114" },
        { :code => "10600", :name => "Praha 106" },
        { :code => "10700", :name => "Praha 112" },
        { :code => "10800", :name => "Praha 108" },
        { :code => "10900", :name => "Praha 111" },
        { :code => "11000", :name => "Praha 1" },
        { :code => "11001", :name => "Praha 01" },
        { :code => "11002", :name => "Praha 02" },
        { :code => "11004", :name => "Praha 04" },
      ]
    end
  end
end


