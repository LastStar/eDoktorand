require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe DisertThemes::Checker do

  context "when parsing theses result" do
    let(:disert_theme) { Factory(:disert_theme, :index => Factory(:index, :student => Factory(:student))) }
    let(:theses_result) { File.read("spec/fixtures/theses_result.xml") }

    before do
      extend DisertThemes::Checker
    end

    it "returns array of created theses results" do
      parse_theses_result(disert_theme, theses_result).first.should be_kind_of(ThesesResult)
    end

    it "returns array of 3  theses results" do
      parse_theses_result(disert_theme, theses_result).size.should == 4
    end

    it "have first theses result with score 5" do
      parse_theses_result(disert_theme, theses_result).first.theses_score.should == 12
    end

    it "have first theses result with filename" do
      parse_theses_result(disert_theme, theses_result).first.theses_filename.should == "xbram201_dp.pdf"
    end

    it "have first theses result with pdf" do
      parse_theses_result(disert_theme, theses_result).first.theses_pdf.should ==
        "https://theses.cz/auth/dok/plag_podobnost_uzlu.pl?u1=b97d6fe871299dc2;u2=e730e171c7159ade;s1=5;s2=5;pdf=1"
    end

  end
end
