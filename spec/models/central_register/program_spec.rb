require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CentralRegister::Program do

  context "when parsing correct response" do
    before do
      mock_service <<BODY
<?xml version='1.0' encoding='UTF-8'?>
<soap:ciselnikyResponse xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <studyPrograms>
    <studyProgram>
      <id>1</id>
      <code>B6202</code>
      <guarantee_uic>51381</guarantee_uic>
      <name>Hospodářská politika a správa</name>
      <name_english>Economic Policy and Administration</name_english>
    </studyProgram>
    <studyProgram>
      <id>2</id>
      <code>B6207</code>
      <guarantee_uic>53475</guarantee_uic>
      <name>Kvantitativní metody v ekonomice</name>
      <name_english>Quantitative Methods in Economics</name_english>
    </studyProgram>
  </studyPrograms>
</soap:ciselnikyResponse>
BODY
    end
    it "it returns array of study program hashes" do
      CentralRegister::Program.all.should == [
        {
          :code => 'B6202',
          :name => 'Hospodářská politika a správa',
          :name_english => 'Economic Policy and Administration',
          :guarantee_uic => '51381',
        },
        {
          :code => 'B6207',
          :name => 'Kvantitativní metody v ekonomice',
          :name_english => 'Quantitative Methods in Economics',
          :guarantee_uic => '53475',
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
  <studyPrograms>
    <studyProgram>
      <code>B6207</code>
      <guarantee_uic>53475</guarantee_uic>
      <name>Kvantitativní metody v ekonomice</name>
    </studyProgram>
  </studyPrograms>
  </ciselnik>
</soap:ciselnikyResponse>
BODY
    end
    it "should not raise error" do
      lambda {CentralRegister::Specialization.all}.should_not raise_error
    end
  end

end
