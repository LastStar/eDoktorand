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

    # prepares XML schema to send to Theses portal
    def prepare_theses_xml(disert_theme)

      # TODO faculty sender.id impl
      sender_id = disert_theme.index.faculty.theses_id

      xml_ret = ""
      xml = Builder::XmlMarkup.new(:target => xml_ret, :indent => 2)
      xml.instruct!
      xml.tag!("pts:metadata", "version"=>"1.0",
        "xmlns:pts".to_sym => "http://theses.cz/pts/elements/1.0/",
        "xmlns:dc".to_sym => "http://purl.org/dc/elements/1.1/",
        "xmlns:dcterms".to_sym => "http://purl.org/dc/terms/",
        "xmlns:dcmitype".to_sym => "http://purl.org/dc/dcmitype/",
        "xmlns:xsi".to_sym => "http://www.w3.org/2001/XMLSchema-instance",
        "xsi:schemaLocation".to_sym =>
        "http://theses.cz/pts/elements/1.0/ http://theses.cz/pts/elements/1.0/schemaTheses.xsd") do
        xml.tag!("pts:thesis") do
          # TODO replace with #{senderId}
          xml.tag!("pts:sender.id") { xml.text! sender_id } # faculty theses_id
          xml.tag!("pts:thesis.id") { xml.text! THESIS_ID_PREFIX + disert_theme.id.to_s } # disert_theme.id
          xml.tag!("dc:title", "xml:lang".to_sym => "cze") { xml.text! disert_theme.title.strip } # disert_theme.title
          if disert_theme.title_en != nil  # disert_theme.title_en
            xml.tag!("pts:title.translated", "xml:lang".to_sym => "eng") { xml.text! disert_theme.title_en.strip }
          end
          if disert_theme.index.defense_claimed_at != nil # submition date in ISO 8601
            xml.tag!("dcterms:dateSubmitted") { xml.text! disert_theme.index.defense_claimed_at.iso8601 }
          end
          xml.tag!("dc:type") { xml.text! DISERT_TYPE } # thesis type
          xml.tag!("dc:language") { xml.text! "cze" } # language
          xml.tag!("pts:degree.name") { xml.text! DEGREE_NAME } # Ph.D.
          xml.tag!("pts:degree.level") { xml.text! DEGREE_LEVEL } # Doktorsky
          xml.tag!("pts:degree.discipline", "xml:lang".to_sym => "cze"){xml.text! disert_theme.index.specialization.name.strip} # specialization czech
          xml.tag!("pts:degree.discipline", "xml:lang".to_sym => "eng") { xml.text! disert_theme.index.specialization.name_english.strip } # specialization english
          xml.tag!("pts:degree.grantor", "xml:lang".to_sym => "cze") { xml.text! CZU } # CZU
          xml.tag!("pts:degree.grantor", "xml:lang".to_sym => "eng") { xml.text! CULS } # CULS
          xml.tag!("pts:degree.grantor.faculty", "xml:lang".to_sym => "cze") { xml.text! disert_theme.index.department.faculty.name.strip } # CZU
          if disert_theme.index.department.faculty.name_english != nil
            xml.tag!("pts:degree.grantor.faculty", "xml:lang".to_sym => "eng") { xml.text! disert_theme.index.department.faculty.name_english.strip }
          end
          xml.tag!("pts:creator", "pts:id".to_sym => disert_theme.index.student.uic.to_s) do
            xml.tag!("pts:foreName") { xml.text! disert_theme.index.student.firstname.strip }
            xml.tag!("pts:surName") { xml.text! disert_theme.index.student.lastname.strip }
          end # creator
          if disert_theme.index.tutor != nil # tutor
            xml.tag!("pts:advisor", "pts:id"=>disert_theme.index.tutor.uic.to_s) do
              xml.tag!("pts:foreName") { xml.text! disert_theme.index.tutor.firstname.strip }
              xml.tag!("pts:surName") { xml.text! disert_theme.index.tutor.lastname.strip }
              xml.tag!("pts:academicTitleBefore") { xml.text! disert_theme.index.tutor.title_before.label.strip }
              xml.tag!("pts:academicTitleAfter") { xml.text! disert_theme.index.tutor.title_after.label.strip }
            end
          end
          xml.tag!("pts:get.file") do
            xml.tag!("pts:url") { xml.text! "http://edoktorand.czu.cz/pdf/disert_theme/#{disert_theme.id.to_s}.pdf" }
            xml.tag!("pts:ctype") { xml.text! "thesis" }
            xml.tag!("pts:author") { xml.text! disert_theme.index.student.uic.to_s }
            xml.tag!("pts:filename") { xml.text! "#{disert_theme.id.to_s}.pdf" }
          end # if FileTest.exists?("http://edoktorand.czu.cz/pdf/disert_theme/#{disert_theme.id.to_s}.pdf") # get file
        end
      end
      return xml_ret
    end

    # sends generated XML to theses.cz portal
    def send_theses(disert_theme)

      # prepare theses xml
      xml_to_send = prepare_theses_xml(disert_theme)

      # tempfile gen
      tf = Tempfile.new("export");
      tf.write(xml_to_send)
      tf.rewind

      result = `curl --insecure -X POST -H 'Content-type: multipart/form-data' -u #{THESIS_USERNAME}:#{THESIS_PASSWORD} -F "soubor=@#{tf.path}" https://theses.cz/auth/th_sprava/neosobni_import_dat.pl`

      res = Nokogiri::XML(result)

      disert_theme.update_attributes(:theses_request => xml_to_send,
                                    :theses_request_at => Time.now,
                                    :theses_request_response => result,
                                    :theses_request_succesfull => false)

      res.xpath('//commited').each do |comNode|
        disert_theme.update_attribute('theses_request_succesfull', true)
      end

      tf.close!
    end

    def check_theses_result(disert_theme)

      # TODO faculty sender.id impl
      sender_id = disert_theme.index.faculty.theses_id

      # TODO replace sender.id with #{senderId}
      result = `curl -u #{THESIS_USERNAME}:#{THESIS_PASSWORD} "https://theses.cz/auth/plagiaty/plag_vskp.pl?pts:sender.id=#{sender_id};pts:thesis.id=#{THESIS_ID_PREFIX + disert_theme.id.to_s}"`

      # puts 'identifier = ' + THESIS_ID_PREFIX + disert_theme.id.to_s

      res = Nokogiri::XML(result)
      res.remove_namespaces!

      res.xpath('//info').each do |statusNode|
        status = statusNode['status']
      end

      #1. - Dokument není v metadatech - neznámé url. Je nutné provést nový import.
      #2. - Dokument je připraven ke stažení (stahování by mělo proběhnout v noci).
      #3. - Dokument je zaveden v systému, ale nemá vytvořenou textovou verzi (může se zobrazit i důvod, proč bylo vytvoření neúspěšné nebo upozornění, že soubor není v textovém formátu ale např. ve formátu .eps apod.).
      #4. - Dokument není zkontrolovaný systémem na odhalování plagiátů - po vytvoření textové verze chvíli trvá, než dojde k nalezení podobností (prvek plg:info se zde nachází v prvku plg:record).
      #5. - K souboru nebyly nalezeny žádné podobnosti (prvek plg:info se zde nachází v prvku plg:record).
      #6. - K souboru byly nalezeny podobnosti, informace najdete ve vnořených prvcích plg:plagiat.
      #7. - Dokument zkontrolován u předchozí verze, podobnosti se teď přepočítávají.
      #8. - Dokument nezkontrolován, je přiliš malý.

      disert_theme.update_attribute('theses_response', result)
      disert_theme.update_attribute('theses_response_at', Time.now)
      disert_theme.update_attribute('theses_status', status)

      if status.to_s == "6"
          parse_theses_result(disert_theme, result)
      end
    end

    # parses theses result obtained from theses.cz after 48 hrs
    def parse_theses_result(disert_theme, theses_result)
      if theses_result.present?
        result = Nokogiri::XML(theses_result)
        result.remove_namespaces!

        # iterates over each plagiat node in document
        result.xpath('//similarDocuments/plagiat').map do |plagiat|
          # create ThesesResult record
          ThesesResult.create do |tr|
            tr.disert_theme = disert_theme
            tr.theses_filename = plagiat.xpath('filename').first.try(:content)
            tr.theses_pdf = plagiat.xpath('similarities[@type = "pdf"]').first.try(:content)
            tr.theses_score = plagiat.xpath('score').first.content
          end
        end
      end

    end

    # Public: Downloads pdf with result of thesis plagiat
    #
    # theses_result - The ThesesResult for which we want to download file
    #
    # Returns true if it was succesful else false
    def download_theses_file(theses_result)
      # should be theses.cz
      uri = URI(theses_result.theses_pdf)

      # create the file path
      file_name =
      path = File.join(THESIS_RESULT_DIR, "#{theses_result.id}.pdf")

      # and download it..
      Net::HTTP.new(uri.host, uri.port, :use_ssl => true).start do |https|
         req = Net::HTTP::Get.new(uri.request_uri)
         req.basic_auth THESIS_USERNAME, THESIS_PASSWORD

         File.open(path, "w+") do |f|
           f.write http.request(req).body
         end
      end
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
