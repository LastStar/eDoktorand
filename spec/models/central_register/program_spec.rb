require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CentralRegister::Program do

  context "when parsing correct response" do
    before do
      mock_service <<BODY
<?xml version='1.0' encoding='UTF-8'?>
<soap:ciselnikyResponse xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <ciselnik>
    <polozka>
      <kod>P6209</kod>
      <nazev>Systémové inženýrství a informatika</nazev>
      <anazev>Engineering and Informatics</anazev>
    </polozka>
  </ciselnik>
</soap:ciselnikyResponse>
BODY
    end
    it "it returns array of specialization hashes" do
      CentralRegister::Program.all.should == [
        {
          :code => 'P6209',
          :name => 'Systémové inženýrství a informatika',
          :name_english => 'Engineering and Informatics'
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
      <kod>P6209</kod>
      <nazev>Systémové inženýrství a informatika</nazev>
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
