# class for getting new uic for students who don't have any
require 'soap/netHttpClient'
require 'log4r'

class UicGetter
  #setup logger for clss
  include Log4r
  @@logger = Logger.new 'UicGetter'
  @@logger.outputters = Outputter.stdout
  @@logger.level = 1

  # constants definition
  SERVICES = {:uic => "http://193.84.34.6/axis2/services/GetUicService/getUicByBirthNum?rc=%s",:pokus => "http://193.84.34.6/axis2/services/GetUicService/getUicByBirthNum?rc=8111191638"}
  UIC_REGEX = /<uic>(-?[0-9]{3,6})<\/uic>/
  MESSAGE_REGEXP = /<message>(.*)<\/message>/

  # initialize with type of service
  def initialize(service = :uic)
    raise 'bad argument' unless service.is_a? Symbol
    @service_path = SERVICES[service]
    @client = SOAP::NetHttpClient.new
  end

  # update uic from central database
  def update_uic(students)
    students.each do |student|
      if student.uic
        @@logger.debug "Student id #{student.id} already has uic #{student.uic}"
        next
      end
      service = prepare_service(student.birth_number.to_s)
      @@logger.debug "Trying service for student id #{student.id} and bn #{student.birth_number}"
      @@logger.debug service
      begin
        service_response = query_service(service)
      rescue Exception => e
        @@logger.error 'Something gone wrong with service ' + e
        next
      end
      begin
        uic = extract_uic(service_response)
        @@logger.debug "Service and parsing successful. Updating student"
        student.update_attribute(:uic, uic)
      rescue Exception => e
        @@logger.error "Error parsing response: " + e
        next
      end
    end
    @@logger.debug "All students done"
    students
  end

  # prepares service path string
  def prepare_service(parameter)
    return @service_path % parameter
  end

  # performs query of the service
  def query_service(service)
    #remove on production/create testing case?
    resp = @client.get_content(service)
    @@logger.debug "Service succesfully queried"

    return resp
  end

  # extracts uic from response
  def extract_uic(resp)
    @@logger.debug resp
    uic = resp.match(UIC_REGEX)[1].to_i
    case uic
    when 0
      @@logger.error 'Service did not returned meaningful response'
      raise 'bad response'
    when -666, -999
      message = resp.match(MESSAGE_REGEXP)[1]
      raise 'bad response: ' + message
    else
      @@logger.debug "Service returned uic #{uic}"
      return uic
    end
  end

end
