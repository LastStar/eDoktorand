module DisertThemesHelper
  
  require "builder"
  
  DISERT_TYPE = "Disertační práce"
  DEGREE_NAME = "Ph.D."
  DEGREE_LEVEL = "Doktorský"
  CZU = "Česká zemědělská univerzita v Praze"
  CULS = "Czech University of Life Sciences Prague"
  
  THESIS_SEND_SERVER = "https://theses.cz/auth/th_sprava/neosobni_import_dat.pl"
  THESIS_USERNAME = "31417"
  THESIS_PASSWORD = "dysfov-eri"
  
  # prepares XML schema to send to Theses portal
  def prepare_theses_xml(disert_theme)
    xml = Builder::XmlMarkup.new(:indent => 2)
    xml.instruct!
    xml.tag!("pts:metadata", "version"=>"1.0", "xmlns:pts".to_sym => "http://theses.cz/pts/elements/1.0/", 
          "xmlns:dc".to_sym => "http://purl.org/dc/elements/1.1/", "xmlns:dcterms".to_sym => "http://purl.org/dc/terms/",
          "xmlns:dcmitype".to_sym => "http://purl.org/dc/dcmitype/", "xmlns:xsi".to_sym => "http://www.w3.org/2001/XMLSchema-instance",
          "xsi:schemaLocation".to_sym => "http://theses.cz/pts/elements/1.0/ http://theses.cz/pts/elements/1.0/schemaTheses.xsd") {
            xml.tag!("pts:thesis") {
              xml.tag!("pts:sender.id"){xml.text! "S4111"} #faculty id
              xml.tag!("pts:theses.id"){xml.text! disert_theme.id.to_s} #disert_theme.id
              xml.tag!("dc:title", "xml:lang".to_sym => "cze"){xml.text! disert_theme.title.strip} #disert_theme.title
              xml.tag!("pts:title.translated", "xml:lang".to_sym => "eng"){xml.text! disert_theme.title_en.strip} if disert_theme.title_en != nil  #disert_theme.title_en
              xml.tag!("dcterms:dateSubmitted"){xml.text! disert_theme.index.defense_claimed_at.iso8601} if disert_theme.index.defense_claimed_at != nil #submition date in ISO 8601 
              xml.tag!("dc:type"){xml.text! DISERT_TYPE} # thesis type
              xml.tag!("dc:language"){xml.text! "cze"} # language
              xml.tag!("pts:degree.name"){xml.text! DEGREE_NAME} # Ph.D.
              xml.tag!("pts:degree.level"){xml.text! DEGREE_LEVEL} # Doktorsky
              xml.tag!("pts:degree.discipline", "xml:lang".to_sym => "cze"){xml.text! disert_theme.index.specialization.name.strip} # specialization czech
              xml.tag!("pts:degree.discipline", "xml:lang".to_sym => "eng"){xml.text! disert_theme.index.specialization.name_english.strip} # specialization english
              xml.tag!("pts:degree.grantor", "xml:lang".to_sym => "cze"){xml.text! CZU} # CZU
              xml.tag!("pts:degree.grantor", "xml:lang".to_sym => "eng"){xml.text! CULS} # CULS
              xml.tag!("pts:degree.grantor.faculty", "xml:lang".to_sym => "cze"){xml.text! disert_theme.index.department.faculty.name.strip} # CZU
              xml.tag!("pts:degree.grantor.faculty", "xml:lang".to_sym => "eng"){xml.text! disert_theme.index.department.faculty.name_english.strip}
              xml.tag!("pts:creator", "pts:id".to_sym => disert_theme.index.student.uic.to_s){
                xml.tag!("pts:foreName"){xml.text! disert_theme.index.student.firstname.strip}
                xml.tag!("pts:surName"){xml.text! disert_theme.index.student.lastname.strip}
              } # creator
              xml.tag!("pts:advisor", "pts:id"=>disert_theme.index.tutor.uic.to_s){
                xml.tag!("pts:foreName"){xml.text! disert_theme.index.tutor.firstname.strip}
                xml.tag!("pts:surName"){xml.text! disert_theme.index.tutor.lastname.strip}
                xml.tag!("pts:academicTitleBefore"){xml.text! disert_theme.index.tutor.title_before.label.strip}
                xml.tag!("pts:academicTitleAfter"){xml.text! disert_theme.index.tutor.title_after.label.strip}
              } if disert_theme.index.tutor != nil # tutor
              xml.tag!("pts:get.file"){
                xml.tag!("pts:url"){xml.text! "http://edoktorand.czu.cz/public/pdf/disert_theme/#{disert_theme.id}.pdf"}
                xml.tag!("pts:ctype"){xml.text! "thesis"}
                xml.tag!("pts:author"){xml.text! disert_theme.index.student.uic.to_s}
                xml.tag!("pts:filename"){xml.text! "#{disert_theme.id}.pdf"}
              }  if FileTest.exists?("http://edoktorand.czu.cz/public/pdf/disert_theme/#{disert_theme.id}.pdf") # get file
            }
          }
    return xml      
  end
  
  def send_theses_xml(xml_to_send)
    c = Curl::Easy.new(THESIS_SEND_SERVER)
    c.http_auth_types = Curl::CURLAUTH_BASIC
    c.username = THESIS_USERNAME
    c.password = THESIS_PASSWORD
    c.ssl_version = Curl::CURL_SSLVERSION_SSLv3
    c.multipart_form_post = true

    post_field = Curl::PostField.content('export', xml_to_send)
    post_field.remote_file = 'export.xml'
    post_field.content_type = 'application/xml'
    c.http_post(post_field)
    
    puts c.body_str
  end
  
end
