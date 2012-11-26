require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ServiceTools::DisertTheme do
  context "when preparing disert theme for sending" do
    before do
      @faculty = Factory(:faculty, :code => 41210)
      @department = Factory(:department, :faculty => @faculty, :code => '31110')
      @specialization = Factory(:specialization, :faculty => @faculty,
                                :msmt_code => '6209V015')
      @student = Factory(:student, :uic => 99999)
      @tutor = Factory(:tutor, :uic => 55555)
      @index = Factory(:index, :student => @student, :tutor => @tutor,
                       :specialization => @specialization, :department => @department)
      @disert_theme = Factory(:disert_theme, :index => @index)
      @disert_theme.defense_passed!('2011-10-10')
    end

    it "it returns hash for sending" do
      ServiceTools::DisertTheme.for_sending(@disert_theme).should == {
        :id_prace => @disert_theme.id,
        :nazev_cz => 'Hnojit nebo nehnojit',
        :nazev_en => 'To shit or not to shit',
        :student_UIC => 99999,
        :vedouci_UIC => 55555,
        :termin_obhajoby => '2011-10-10 00:00:00',
        :fakulta => 41210,
        :utvar => '31110',
        :obor => '6209V015',
        :prace_URL => "http://edoktorand.czu.cz/pdf/disert_theme/#{@disert_theme.id}.pdf",
        :autoreferat_URL => "http://edoktorand.czu.cz/pdf/self_report/#{@disert_theme.id}.pdf",
        :posudek_oponent_URL => "http://edoktorand.czu.cz/pdf/opponent_review/#{@disert_theme.id}.pdf"
      }
    end
  end
end

