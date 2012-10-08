require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require "nokogiri"

describe DisertThemes::Checker do
  let(:disert_theme) { Factory(:disert_theme, :index => Factory(:index, :student => Factory(:student))) }
  before do
    extend DisertThemes::Checker
  end

  describe "#parse_result" do
    let(:theses_result) { File.read("spec/fixtures/theses_result.xml") }

    it "returns array of created theses results" do
      parse_result(theses_result).first.should be_kind_of(ThesesResult)
    end

    it "returns array of 3  theses results" do
      parse_result(theses_result).size.should == 4
    end

    it "have first theses result with score 5" do
      parse_result(theses_result).first.theses_score.should == 12
    end

    it "have first theses result with filename" do
      parse_result(theses_result).first.theses_filename.should == "xbram201_dp.pdf"
    end

    it "have first theses result with pdf" do
      parse_result(theses_result).first.theses_pdf.should ==
        "https://theses.cz/auth/dok/plag_podobnost_uzlu.pl?u1=b97d6fe871299dc2;u2=e730e171c7159ade;s1=5;s2=5;pdf=1"
    end

  end

  describe "#check_result" do
    before do
      Factory(:faculty_secretary,
              :faculty_employment => FacultyEmployment.create(:unit_id => disert_theme.index.faculty.id))

    end
    it "returns true on success" do
      Curl::Easy.should_receive(:perform).and_return(File.read("spec/fixtures/theses_check_response_6.xml"))
      check_result(disert_theme).should be_kind_of(Array)
    end

    it "returns false when something wrong with net" do
      Curl::Easy.should_receive(:perform).and_raise RuntimeError
      check_result(disert_theme).should be_false
    end
  end

  describe "#prepare_xml" do
    let(:xml) { Nokogiri::XML(prepare_xml(disert_theme)) }

    it "contains specialization" do
      xml.xpath("//pts:degree.discipline").first.text.strip.should == "specialization"
    end

    it "contains file url" do
      xml.xpath("//pts:url").first.text.strip.should == "http://edoktorand.czu.cz/pdf/disert_theme/#{disert_theme.id}.pdf"
    end
  end

  describe "#send_theses" do
    subject { send_theses(disert_theme) }

    context "when request succesful" do
      before do
        Curl::Easy.should_receive(:perform).and_return(File.read("spec/fixtures/theses_response.xml"))
      end

      it { should be_true }
    end

    context "when request failed" do
      it "return false" do
        pending
      end
    end
  end
end
