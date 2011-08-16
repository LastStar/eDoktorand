require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CentralRegister::Specialization do

  context "when parsing correct response" do
    before do
      mock_service <<BODY
<?xml version='1.0' encoding='UTF-8'?>
<soap:ciselnikyResponse xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <specializations>
    <specialization>
      <id>3</id>
      <code>6208R110</code>
      <guarantee_uic>51579</guarantee_uic>
      <name>Agricultural Economics and Management</name>
      <name_english>Agricultural Economics and Management</name_english>
    </specialization>
    <specialization>
      <id>6</id>
      <code>1604V001</code>
      <guarantee_uic>0</guarantee_uic>
      <name>Aplikovaná a krajinná ekologie</name>
      <name_english/>
    </specialization>
  </specializations>
</soap:ciselnikyResponse>
BODY
    end
    it "it returns array of specialization hashes" do
      CentralRegister::Specialization.all.should == [
        {
          :code => '6208R110',
          :guarantee_uic => '51579',
          :name => 'Agricultural Economics and Management',
          :name_english => 'Agricultural Economics and Management',
        },
        {
          :code => '1604V001',
          :guarantee_uic => '0',
          :name => 'Aplikovaná a krajinná ekologie',
          :name_english => nil,
        }
      ]
    end
  end
  context "when parsing response with some nil" do
    before do
      mock_service <<BODY
<?xml version='1.0' encoding='UTF-8'?>
<soap:ciselnikyResponse xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <specializations>
    <specialization>
      <id>3</id>
      <code>6208R110</code>
      <guarantee_uic>51579</guarantee_uic>
      <name>Agricultural Economics and Management</name>
    </specialization>
  </specializations>
</soap:ciselnikyResponse>
BODY
    end
    it "should not raise error" do
      lambda {CentralRegister::Specialization.all}.should_not raise_error
    end
  end

end
