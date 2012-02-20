module DisertThemesHelper
  
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
  
  # prepares XML schema to send to Theses portal
  def prepare_theses_xml(disert_theme)
    
    #TODO faculty sender.id impl
    sender_id = disert_theme.index.faculty.theses_id
    
    xml_ret = ""
    xml = Builder::XmlMarkup.new(:target => xml_ret, :indent => 2)
    xml.instruct!
    xml.tag!("pts:metadata", "version"=>"1.0", "xmlns:pts".to_sym => "http://theses.cz/pts/elements/1.0/", 
          "xmlns:dc".to_sym => "http://purl.org/dc/elements/1.1/", "xmlns:dcterms".to_sym => "http://purl.org/dc/terms/",
          "xmlns:dcmitype".to_sym => "http://purl.org/dc/dcmitype/", "xmlns:xsi".to_sym => "http://www.w3.org/2001/XMLSchema-instance",
          "xsi:schemaLocation".to_sym => "http://theses.cz/pts/elements/1.0/ http://theses.cz/pts/elements/1.0/schemaTheses.xsd") {
            xml.tag!("pts:thesis") {
              # TODO replace with #{senderId}
              xml.tag!("pts:sender.id"){xml.text! sender_id} #faculty theses_id
              xml.tag!("pts:thesis.id"){xml.text! THESIS_ID_PREFIX + disert_theme.id.to_s} #disert_theme.id
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
              xml.tag!("pts:degree.grantor.faculty", "xml:lang".to_sym => "eng"){xml.text! disert_theme.index.department.faculty.name_english.strip} if disert_theme.index.department.faculty.name_english != nil
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
    return xml_ret      
  end
  
  #sends generated XML to theses.cz portal
  def send_theses_xml(disert_theme)
    
    # prepare theses xml
    xml_to_send = prepare_theses_xml(disert_theme)
    
    #tempfile gen
    tf = Tempfile.new("export");
    tf.write(xml_to_send)
    tf.rewind
    
    result = `curl --insecure -X POST -H 'Content-type: multipart/form-data' -u #{THESIS_USERNAME}:#{THESIS_PASSWORD} -F "soubor=@#{tf.path}" https://theses.cz/auth/th_sprava/neosobni_import_dat.pl`
    
    res = Nokogiri::XML(result)
    
    disert_theme.update_attribute('theses_request', xml_to_send)
    disert_theme.update_attribute('theses_request_at', Time.now)
    disert_theme.update_attribute('theses_request_response', result)
    disert_theme.update_attribute('theses_request_succesfull', false)
    
    res.xpath('//commited').each do |comNode|
      disert_theme.update_attribute('theses_request_succesfull', true)
    end
    
    tf.close!
  end
  
  def check_theses_result(disert_theme)
    
    #TODO faculty sender.id impl
    senderId = disert_theme.index.faculty.theses_id
    
    #TODO replace sender.id with #{senderId}
    result = `curl -u #{THESIS_USERNAME}:#{THESIS_PASSWORD} "https://theses.cz/auth/plagiaty/plag_vskp.pl?pts:sender.id=#{senderId};pts:thesis.id=#{THESIS_ID_PREFIX + disert_theme.id.to_s}"`
    
    res = Nokogiri::XML(result)
    res.remove_namespaces!
    
    status = -1
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
        
    case Integer(status.to_s)
      when 5 then
        #TODO implement no similarities
        disert_theme.update_attribute('theses_response', result)
        disert_theme.update_attribute('theses_response_at', Time.now)
        disert_theme.update_attribute('teses_status', status)
      when 6 then
        #TODO similarities found
        disert_theme.update_attribute('theses_response', result)
        disert_theme.update_attribute('theses_response_at', Time.now)
        disert_theme.update_attribute('theses_status', status)
        
        #parse theses result and create theses_result records
        parse_theses_result(result, disert_theme)
      else
        #TODO implement default action
    end
    
    # TODO implement status save, and result save
    
  end 
  
  #parses theses result obtained from theses.cz after 48 hrs
  def parse_theses_result(theses_result, disert_theme)
    
    if theses_result.length > 0 
    
      result = Nokogiri::XML(theses_result)
      result.remove_namespaces!
      
      #iterates over each plagiat node in document  
      result.xpath('//similarDocuments/plagiat').each do |plagiat|
        #parse file name of similarity
        fileName = plagiat.xpath('filename').first
        
        #parse similarity of type pdf => link to desired pdf report
        similar = ""
        plagiat.xpath('similarities[@type = "pdf"]').each do |similar|
          similar = similar.text if similar
        end
      
        #parse similarity score
        score = plagiat.xpath('score').first
        
        #create ThesesResult record
        tr = ThesesResult.new
        tr.disert_theme_id = disert_theme.id #disert_theme
        tr.theses_filename = fileName.text
        tr.theses_pdf = similar
        tr.theses_score = score
        tr.save
        
        #clean variables
        filename = ""
        similar = ""
        score = 0
      end
    end
    
  end
  
  # method takes four arguments: disertTheme, name of theses file to download, the number of the file used for name generation,
  # and the last argument is path where we should download the file..
  def download_theses_file(disert_theme, theses_file, numFile, destination_dir)
    # should be theses.cz
    domain = theses_file.split('/')[2]
    
    # the rest after theses.cz/........ (file to download)
    rest = ""
    i = 0
    theses_file.split('/').each do |part|
      if i > 2 
        if i > 3
          rest = rest + '/' 
        end
        rest = rest + part
      end
      i = i + 1
    end
    
    # create the file path
    fileName = 'dsp_' + disert_theme.id.to_s + '_similar_' + numFile.to_s + '.pdf'
    path = File.join(destination_dir, fileName)
    
    # and download it..
    http = Net::HTTP.new(domain, 443)
    http.use_ssl = true
    http.start() { |http|
         req = Net::HTTP::Get.new('/' + rest)
         req.basic_auth THESIS_USERNAME, THESIS_PASSWORD
         response = http.request(req)
         
         File.open(path, "w+") do |f|
           f.write response.body
           puts "File = " + f.path
         end
      }
  end
  
  # periodically checks for disert_themes in DB and after the 48hrs interval of request, checks for results..
  def periodic_theses_check()
    disert_themes_to_check = DisertTheme.ready_for_theses_check(2).each do |disert_theme|
      check_theses_result(disert_theme)
    end
  end
    
end
