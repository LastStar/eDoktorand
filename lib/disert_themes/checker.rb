module DisertThemes
  module Checker
    require "builder"
    require 'tempfile'
    require 'nokogiri'
    require 'open-uri'

    DISERT_TYPE = "Disertační práce"
    DEGREE_NAME = "Ph.D."
    DEGREE_LEVEL = "Doktorský"
    CZU = "Česká zemědělská univerzita v Praze"
    CULS = "Czech University of Life Sciences Prague"

    THESIS_SEND_SERVER = "https://theses.cz/auth/th_sprava/neosobni_import_dat.pl"
    THESIS_USERNAME = "31417"
    THESIS_PASSWORD = "dysfov-eri"
    THESIS_ID_PREFIX = "dsp_"
    THESIS_RESULT_DIR = "public/pdf/thesis_result"

    DT_LOCATION = "http://edoktorand.czu.cz/pdf/disert_theme/%s.pdf"

    # Internal: prepares XML schema to send to Theses portal
    #
    # disert_theme - The DisertTheme for which prepare the xml
    #
    # Returns string with xml
    def prepare_xml(disert_theme)

      # TODO faculty sender.id impl
      sender_id = disert_theme.index.faculty.theses_id

      xml_ret = ""
      xml = Builder::XmlMarkup.new(:target => xml_ret, :indent => 2)
      xml.instruct!
      xml.tag!("pts:metadata", "version" => "1.0",
        "xmlns:pts" => "http://theses.cz/pts/elements/1.0/",
        "xmlns:dc" => "http://purl.org/dc/elements/1.1/",
        "xmlns:dcterms" => "http://purl.org/dc/terms/",
        "xmlns:dcmitype" => "http://purl.org/dc/dcmitype/",
        "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
        "xsi:schemaLocation" =>
        "http://theses.cz/pts/elements/1.0/ http://theses.cz/pts/elements/1.0/schemaTheses.xsd") do
        xml.tag!("pts:thesis") do
          xml.tag!("pts:sender.id") { xml.text! sender_id }
          xml.tag!("pts:thesis.id") {
            xml.text! THESIS_ID_PREFIX + disert_theme.id.to_s }
          xml.tag!("dc:title", "xml:lang" => "cze") {
            xml.text! disert_theme.title.strip }
          if disert_theme.title_en
            xml.tag!("pts:title.translated", "xml:lang" => "eng") {
              xml.text! disert_theme.title_en.strip }
          end
          if disert_theme.index.defense_claimed_at.present?
            xml.tag!("dcterms:dateSubmitted") {
              xml.text! disert_theme.index.defense_claimed_at.iso8601 }
          end
          xml.tag!("dc:type") { xml.text! DISERT_TYPE }
          xml.tag!("dc:language") { xml.text! "cze" }
          xml.tag!("pts:degree.name") { xml.text! DEGREE_NAME }
          xml.tag!("pts:degree.level") { xml.text! DEGREE_LEVEL }
          xml.tag!("pts:degree.discipline", "xml:lang" => "cze") {
            xml.text! disert_theme.index.specialization.name.strip }
          xml.tag!("pts:degree.discipline", "xml:lang" => "eng") {
            xml.text! disert_theme.index.specialization.name_english.strip }
          xml.tag!("pts:degree.grantor", "xml:lang" => "cze") { xml.text! CZU }
          xml.tag!("pts:degree.grantor", "xml:lang" => "eng") { xml.text! CULS }
          xml.tag!("pts:degree.grantor.faculty", "xml:lang" => "cze") {
            xml.text! disert_theme.index.department.faculty.name.strip }
          if disert_theme.index.department.faculty.name_english.present?
            xml.tag!("pts:degree.grantor.faculty", "xml:lang" => "eng") {
              xml.text! disert_theme.index.department.faculty.name_english.strip
            }
          end
          xml.tag!("pts:creator",
                   "pts:id" => disert_theme.index.student.uic.to_s) do
            xml.tag!("pts:foreName") {
              xml.text! disert_theme.index.student.firstname.strip }
            xml.tag!("pts:surName") {
              xml.text! disert_theme.index.student.lastname.strip }
          end
          if disert_theme.index.tutor
            xml.tag!("pts:advisor",
                     "pts:id" => disert_theme.index.tutor.uic.to_s) do
              xml.tag!("pts:foreName") {
                xml.text! disert_theme.index.tutor.firstname.strip }
              xml.tag!("pts:surName") {
                xml.text! disert_theme.index.tutor.lastname.strip }
              xml.tag!("pts:academicTitleBefore") {
                xml.text! disert_theme.index.tutor.title_before.label.strip }
              xml.tag!("pts:academicTitleAfter") {
                xml.text! disert_theme.index.tutor.title_after.label.strip }
            end
          end
          xml.tag!("pts:get.file") do
            xml.tag!("pts:url") {
              xml.text! DT_LOCATION % disert_theme.id }
            xml.tag!("pts:ctype") { xml.text! "thesis" }
            xml.tag!("pts:author") {
              xml.text! disert_theme.index.student.uic.to_s }
            xml.tag!("pts:filename") { xml.text! "#{disert_theme.id.to_s}.pdf" }
          end
        end
      end
      return xml_ret
    end

    # sends generated XML to theses.cz portal
    def send_theses(disert_theme)

      # prepare theses xml
      xml_to_send = prepare_xml(disert_theme)

      # tempfile gen
      tf = Tempfile.new("export");
      tf.write(xml_to_send)
      tf.rewind


      #TODO all URL to CONSTS
      response = Curl::Easy.perform("https://theses.cz/auth/th_sprava/neosobni_import_dat.pl") do |curl|
        c.multipart_form_post = true
        curl.http_auth_types = :basic
        curl.username = THESIS_USERNAME
        curl.password = THESIS_PASSWORD
      end
      # result = `curl --insecure -X POST -H 'Content-type: multipart/form-data' -u #{THESIS_USERNAME}:#{THESIS_PASSWORD} -F "soubor=@#{tf.path}" `


      disert_theme.update_attributes(:theses_request => xml_to_send,
                                    :theses_request_at => Time.now,
                                    :theses_request_response => response)

      unless Nokogiri::XML(response).xpath('//commited').empty?
        disert_theme.update_attribute('theses_request_succesfull', true)
      end

      tf.close!
      return true
    end

    # Internal: Checks result for given disert theme on the theses server
    #
    # Should be used only  through call of the check_result method
    #
    # disert_theme - The DisertTheme for which we are checking results
    #
    # Returns the Array of ThesesResult on success, false when something went wrong
    def check_result(disert_theme)
      thesis_id = THESIS_ID_PREFIX + disert_theme.id.to_s
      sender_id = disert_theme.index.faculty.theses_id
      uri = "https://theses.cz/auth/plagiaty/plag_vskp.pl?pts:sender.id=#{sender_id};pts:thesis.id=#{thesis_id}"

      begin
        response = Curl::Easy.perform(uri) do |curl|
          curl.http_auth_types = :basic
          curl.username = THESIS_USERNAME
          curl.password = THESIS_PASSWORD
        end
      rescue
        return false
      end

      res = Nokogiri::XML(response)
      res.remove_namespaces!
      status = res.xpath('//info[@status]').first["status"]

      disert_theme.update_attribute('theses_response', response)
      disert_theme.update_attribute('theses_response_at', Time.now)
      disert_theme.update_attribute('theses_status', status)

      if status == "6"
        disert_theme.theses_results = parse_result(response)
        Notifications::deliver_plagiat_found(disert_theme)
      end
      return disert_theme.theses_results
    end

    # Internal: Parses theses result obtained from theses.cz after 48 hrs
    #
    # theses_result - string with theses result XML
    #
    # Returns the Array of ThesesResult
    def parse_result(theses_result)
      if theses_result.present?
        result = Nokogiri::XML(theses_result)
        result.remove_namespaces!

        # iterates over each plagiat node in document
        result.xpath('//similarDocuments/plagiat').map do |plagiat|
          # create ThesesResult record
          ThesesResult.new do |tr|
            tr.theses_filename = plagiat.xpath('filename').first.try(:content)
            tr.theses_pdf = plagiat.xpath('similarities[@type = "pdf"]').first.try(:content)
            tr.theses_score = plagiat.xpath('score').first.content
          end
        end
      end

    end

    # TODO spec it
    # Public: Downloads pdf with result of thesis plagiat
    #
    # theses_result - The ThesesResult for which we want to download file
    #
    # Returns true if it was succesful else false
    def download_theses_file(theses_result)
      # should be theses.cz
      uri = URI(theses_result.theses_pdf)

      # create the file path
      path = File.join(THESIS_RESULT_DIR, "#{theses_result.id}.pdf")

      unless File.exists?(path)
        # and download it..
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        https.start do |http|
          req = Net::HTTP::Get.new(uri.request_uri)
          req.basic_auth THESIS_USERNAME, THESIS_PASSWORD

          File.open(path, "wb") do |f|
            f.write http.request(req).body
          end
        end
      end

      return path
    end

    # periodically checks for disert_themes in DB and after the 48hrs interval of request, checks for results..
    def receive_results
      DisertTheme.ready_for_theses_check.each do |disert_theme|
        check_theses_result(disert_theme)
      end
    end

    def send_for_check
      DisertTheme.ready_to_send_to_theses_check.each do |disert_theme|
        send_to_theses(disert_theme)
      end
    end

  end
end
