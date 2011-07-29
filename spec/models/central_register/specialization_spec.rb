require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CentralRegister::Specialization do

  context "when parsing correct response" do
    before do
      mock_service <<BODY
<?xml version='1.0' encoding='UTF-8'?>
<soap:ciselnikyResponse xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <ciselnik>
    <polozka>
      <kod>XINM</kod>
      <nazev>Informační management</nazev>
      <anazev>Information Management</anazev>
    </polozka>
  </ciselnik>
</soap:ciselnikyResponse>
BODY
    end
    it "it returns array of specialization hashes" do
      CentralRegister::Specialization.all.should == [
        {
          :code => 'XINM',
          :name => 'Informační management',
          :name_english => 'Information Management'
        }
      ]
    end
  end
  context "when parsing response with some nil" do
    before do
      mock_service <<BODY
<?xml version='1.0' encoding='UTF-8'?>
<soap:ciselnikyResponse xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <ciselnik>
    <polozka>
      <kod>XINM</kod>
      <nazev>Informační management</nazev>
      <anazev/>
    </polozka>
  </ciselnik>
</soap:ciselnikyResponse>
BODY
    end
    it "should not raise error" do
      lambda {CentralRegister::Specialization.all}.should_not raise_error
    end
  end

end
