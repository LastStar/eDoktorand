require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CentralRegister::DisertTheme do
  context "when putting disert theme to service" do
    before do
      mock_service <<BODY
<soap:vskpResponse xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <thesis>
    <id>1</id>
  </thesis>
</soap:vskpResponse>
BODY
    end
    it "it sends disert theme to service" do
      CentralRegister::DisertTheme.send({
        :id_prace => '1',
        :nazev_cz => 'Hnojit nebo nehnojit',
        :nazev_en => 'To shit or not to shit',
        :student_UIC => 99999,
        :vedouci_UIC => 55555,
        :termin_obhajoby => '2011-10-10 00:00:00',
        :fakulta => 41210,
        :utvar => 31110,
        :obor => '6209V015',
        :prace_URL => 'http://edoktorand.czu.cz/pdf/disert_themes/1.pdf',
        :autoreferat_URL => 'http://edoktorand.czu.cz/pdf/self_report/1.pdf',
        :posudek_oponent_URL => 'http://edoktorand.czu.cz/pdf/opponent_review/1.pdf'
      }).should == '1'
    end
  end
end

